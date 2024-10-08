<!--
  - SPDX-FileCopyrightText: 2023 Nextcloud GmbH and Nextcloud contributors
  - SPDX-License-Identifier: AGPL-3.0-or-later
-->

<template>
	<NcDialog :name="t('collectives', 'Members of collective {name}', { name: collective.name })"
		size="normal"
		@closing="onClose">
		<div class="modal-collective-members">
			<MemberPicker :show-current="true"
				:circle-id="collective.circleId"
				:current-user-is-admin="currentUserIsAdmin"
				:current-members="circleMembersSorted(collective.circleId)"
				:on-click-searched="onClickSearched" />
		</div>
	</NcDialog>
</template>

<script>
import { mapActions, mapState } from 'pinia'
import { useCirclesStore } from '../../stores/circles.js'
import { useCollectivesStore } from '../../stores/collectives.js'
import { autocompleteSourcesToCircleMemberTypes, circlesMemberTypes } from '../../constants.js'
import { NcDialog } from '@nextcloud/vue'
import MemberPicker from '../Member/MemberPicker.vue'

export default {
	name: 'CollectiveMembersModal',

	components: {
		MemberPicker,
		NcDialog,
	},

	props: {
		collective: {
			required: true,
			type: Object,
		},
	},

	computed: {
		...mapState(useCirclesStore, ['circleMembersSorted']),
		...mapState(useCollectivesStore, ['isCollectiveAdmin']),

		currentUserIsAdmin() {
			return this.isCollectiveAdmin(this.collective)
		},
	},

	beforeMount() {
		this.getCircleMembers(this.collective.circleId)
	},

	methods: {
		...mapActions(useCirclesStore, ['getCircleMembers', 'addMemberToCircle']),
		...mapActions(useCollectivesStore, ['setMembersCollectiveId']),

		onClose() {
			this.$emit('close')
		},

		async onClickSearched(member) {
			if (!this.currentUserIsAdmin) {
				return
			}

			await this.addMemberToCircle({
				circleId: this.collective.circleId,
				userId: member.id,
				type: circlesMemberTypes[autocompleteSourcesToCircleMemberTypes[member.source]],
			})
			await this.getCircleMembers(this.collective.circleId)
		},
	},
}
</script>

<style lang="scss" scoped>
.modal-collective-members {
	height: 550px;
	max-height: 80vh;
	padding-bottom: 12px;
}
</style>
