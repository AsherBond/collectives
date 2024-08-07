<!--
  - SPDX-FileCopyrightText: 2023 Nextcloud GmbH and Nextcloud contributors
  - SPDX-License-Identifier: AGPL-3.0-or-later
-->

<template>
	<div class="members-widget">
		<SkeletonLoading v-if="loading"
			type="avatar"
			:count="3"
			class="members-widget-skeleton" />
		<div v-else ref="members" class="members-widget-members">
			<NcAvatar v-for="member in trimmedMembers"
				:key="member.singleId"
				:user="member.userId"
				:display-name="member.displayName"
				:is-no-user="isNoUser(member)"
				:icon-class="iconClass(member)"
				:disable-menu="true"
				:tooltip-message="member.displayName"
				:size="avatarSize" />
			<NcButton type="secondary"
				:title="t('collectives', 'Show members')"
				:aria-label="t('collectives', 'Show all members of the collective')"
				@click="openCollectiveMembers()">
				<template #icon>
					<DotsHorizontalIcon :size="16" />
				</template>
			</NcButton>
		</div>
	</div>
</template>

<script>
import debounce from 'debounce'
import { mapActions, mapState } from 'pinia'
import { useCirclesStore } from '../../../stores/circles.js'
import { useCollectivesStore } from '../../../stores/collectives.js'
import { usePagesStore } from '../../../stores/pages.js'
import { NcAvatar, NcButton } from '@nextcloud/vue'
import DotsHorizontalIcon from 'vue-material-design-icons/DotsHorizontal.vue'
import SkeletonLoading from '../../SkeletonLoading.vue'
import { circlesMemberTypes } from '../../../constants.js'

export default {
	name: 'MembersWidget',

	components: {
		DotsHorizontalIcon,
		NcAvatar,
		NcButton,
		SkeletonLoading,
	},

	data() {
		return {
			showMembersCount: 3,
			updateShowMembersCountDebounced: debounce(this.updateShowMembersCount, 50),
		}
	},

	computed: {
		...mapState(useCirclesStore, [
			'circleMembersSorted',
			'circleMemberType',
		]),
		...mapState(useCollectivesStore, ['currentCollective']),
		...mapState(usePagesStore, ['recentPagesUserIds']),

		sortedMembers() {
			return this.circleMembersSorted(this.currentCollective.circleId)
				.slice()
				.sort(this.sortLastActiveFirst)
		},

		trimmedMembers() {
			return this.sortedMembers
				.slice(0, this.showMembersCount)
		},

		loading() {
			return this.trimmedMembers.length === 0
		},

		isNoUser() {
			return function(member) {
				return this.circleMemberType(member) !== circlesMemberTypes.TYPE_USER
			}
		},

		avatarSize() {
			return parseInt(window.getComputedStyle(document.body).getPropertyValue('--default-clickable-area'))
		},

		iconClass() {
			return function(member) {
				return this.isNoUser(member) ? 'icon-group-white' : null
			}
		},
	},

	watch: {
		'sortedMembers.length'() {
			this.$nextTick(() => {
				this.updateShowMembersCountDebounced()
			})
		},
	},

	beforeMount() {
		this.getCircleMembers(this.currentCollective.circleId)
	},

	mounted() {
		window.addEventListener('resize', this.updateShowMembersCountDebounced)
	},

	unmounted() {
		window.removeEventListener('resize', this.updateShowMembersCountDebounced)
	},

	methods: {
		...mapActions(useCirclesStore, ['getCircleMembers']),
		...mapActions(useCollectivesStore, ['setMembersCollectiveId']),

		updateShowMembersCount() {
			// How many avatars (default-clickable-area + 12px gap) fit? Subtract one for the more button.
			const membersWidth = this.$refs.members?.clientWidth
			const defaultClickableArea = parseInt(window.getComputedStyle(document.body).getPropertyValue('--default-clickable-area'))
			const avatarHeight = defaultClickableArea + 12
			if (membersWidth) {
				const maxMembers = Math.floor(membersWidth / avatarHeight) - 1
				this.showMembersCount = Math.min(this.sortedMembers.length, maxMembers)
			}
		},

		openCollectiveMembers() {
			this.setMembersCollectiveId(this.currentCollective.id)
		},

		/**
		 * @param {object} m1 First member
		 * @param {string} m1.userId First member user ID
		 * @param {object} m2 Second member
		 * @param {string} m2.userId Second member user ID
		 */
		sortLastActiveFirst(m1, m2) {
			if (this.recentPagesUserIds.includes(m1.userId) && this.recentPagesUserIds.includes(m2.userId)) {
				return this.recentPagesUserIds.indexOf(m1.userId) > this.recentPagesUserIds.indexOf(m2.userId)
			} else if (this.recentPagesUserIds.includes(m1.userId)) {
				return -1
			} else if (this.recentPagesUserIds.includes(m2.userId)) {
				return 1
			}
		},
	},
}
</script>

<style lang="scss" scoped>
.members-widget {
	flex-grow: 1;
}

.members-widget-skeleton {
	height: var(--default-clickable-area);
}

.members-widget-members {
	display: flex;
	flex-direction: row;
	gap: 12px;
}
</style>
