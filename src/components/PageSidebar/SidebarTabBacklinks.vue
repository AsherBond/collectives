<!--
  - SPDX-FileCopyrightText: 2021 Nextcloud GmbH and Nextcloud contributors
  - SPDX-License-Identifier: AGPL-3.0-or-later
-->

<template>
	<div class="backlinks-container">
		<!-- loading -->
		<NcEmptyContent v-if="loading('backlinks')">
			<template #icon>
				<NcLoadingIcon />
			</template>
		</NcEmptyContent>

		<!-- error message -->
		<NcEmptyContent v-else-if="error" :name="error">
			<template #icon>
				<AlertOctagonIcon />
			</template>
		</NcEmptyContent>

		<!-- backlinks list -->
		<div v-else-if="!loading('backlinks') && backlinks.length">
			<ul class="backlink-list">
				<NcListItem v-for="backlinkPage in backlinks"
					:key="backlinkPage.id"
					:name="pagePathTitle(backlinkPage)"
					:to="pagePath(backlinkPage)"
					class="backlink">
					<template #icon>
						<div v-if="backlinkPage.emoji"
							class="item-icon item-icon__emoji">
							{{ backlinkPage.emoji }}
						</div>
						<PageIcon v-else
							:size="26"
							fill-color="var(--color-main-background)"
							class="item-icon item-icon__page" />
					</template>
					<template #subname>
						{{ lastUpdate(page) }}
					</template>
				</NcListItem>
			</ul>
		</div>

		<!-- no backlinks found -->
		<NcEmptyContent v-else
			:name="t('collectives', 'No backlinks available')"
			:description="t( 'collectives', 'If other pages link to this one, they will be listed here.')">
			<template #icon>
				<ArrowBottomLeftIcon />
			</template>
		</NcEmptyContent>
	</div>
</template>

<script>
import { mapActions, mapState } from 'pinia'
import { useRootStore } from '../../stores/root.js'
import { usePagesStore } from '../../stores/pages.js'
import { NcEmptyContent, NcListItem, NcLoadingIcon } from '@nextcloud/vue'
import moment from '@nextcloud/moment'
import AlertOctagonIcon from 'vue-material-design-icons/AlertOctagon.vue'
import ArrowBottomLeftIcon from 'vue-material-design-icons/ArrowBottomLeft.vue'
import PageIcon from '../Icon/PageIcon.vue'

export default {
	name: 'SidebarTabBacklinks',

	components: {
		AlertOctagonIcon,
		NcEmptyContent,
		NcListItem,
		NcLoadingIcon,
		ArrowBottomLeftIcon,
		PageIcon,
	},

	props: {
		page: {
			type: Object,
			required: true,
		},
	},

	data() {
		return {
			error: '',
		}
	},

	computed: {
		...mapState(useRootStore, [
			'loading',
		]),
		...mapState(usePagesStore, [
			'backlinks',
			'pagePath',
			'pagePathTitle',
		]),

		lastUpdate() {
			return (page) => moment.unix(page.timestamp).fromNow()
		},
	},

	watch: {
		'page.id'() {
			this.load('backlinks')
			this.getBacklinksForPage()
		},
	},

	mounted() {
		this.load('backlinks')
		this.getBacklinksForPage()
	},

	methods: {
		...mapActions(useRootStore, ['done', 'load']),
		...mapActions(usePagesStore, ['getBacklinks']),

		/**
		 * Get backlinks for a page
		 */
		async getBacklinksForPage() {
			try {
				await this.getBacklinks(this.page)
			} catch (e) {
				this.error = t('collectives', 'Could not get page backlinks')
				console.error('Failed to get page backlinks', e)
			} finally {
				this.done('backlinks')
			}
		},
	},
}
</script>

<style lang="scss" scoped>
.backlink {
	display: flex;
	flex-direction: row;

	:deep(.line-one__name) {
		font-weight: normal;
	}

	.item-icon {
		height: 34px;
		border-radius: var(--border-radius);

		&__emoji {
			display: flex;
			align-items: center;
			justify-content: center;
			width: 26px;
			font-size: 1.3em;
		}

		&__page {
			background-color: var(--color-background-darker);
		}
	}
}
</style>
