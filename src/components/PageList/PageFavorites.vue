<!--
  - SPDX-FileCopyrightText: 2024 Nextcloud GmbH and Nextcloud contributors
  - SPDX-License-Identifier: AGPL-3.0-or-later
-->

<template>
	<div class="page-list-favorites">
		<div class="app-content-list-item">
			<div class="app-content-list-item-icon" @click="toggleFavorites">
				<StarIcon :size="22" fill-color="var(--color-main-text)" />
			</div>
			<div class="app-content-list-item-line-one" @click="toggleFavorites">
				{{ t('collectives', 'Favorites') }}
				<NcButton :aria-label="t('collectives', 'Toggle favorites')"
					type="tertiary"
					class="toggle-favorites-button">
					<template #icon>
						<ChevronDownIcon :size="22"
							:class="{ 'collapsed': !showFavoritesOpen }" />
					</template>
				</NcButton>
			</div>
		</div>

		<div v-show="showFavoritesOpen" class="page-list-favorites-list">
			<Item v-for="page in favoritePages"
				:key="page.title"
				:to="pagePath(page)"
				:page-id="page.id"
				:parent-id="page.parentId"
				:title="page.title"
				:timestamp="page.timestamp"
				:last-user-id="page.lastUserId"
				:last-user-display-name="page.lastUserDisplayName"
				:emoji="page.emoji"
				:level="2"
				:can-edit="currentCollectiveCanEdit"
				:in-favorite-list="true"
				:filtered-view="false"
				@click.native="show('details')" />
		</div>
	</div>
</template>

<script>
import { mapActions, mapState } from 'pinia'
import { useRootStore } from '../../stores/root.js'
import { useCollectivesStore } from '../../stores/collectives.js'
import { usePagesStore } from '../../stores/pages.js'
import { NcButton } from '@nextcloud/vue'
import Item from './Item.vue'
import ChevronDownIcon from 'vue-material-design-icons/ChevronDown.vue'
import StarIcon from 'vue-material-design-icons/Star.vue'

export default {
	name: 'PageFavorites',

	components: {
		Item,
		NcButton,
		ChevronDownIcon,
		StarIcon,
	},

	data() {
		return {
			showFavoritesOpen: true,
		}
	},

	computed: {
		...mapState(useCollectivesStore, [
			'currentCollectiveCanEdit',
		]),
		...mapState(usePagesStore, [
			'favoritePages',
			'pagePath',
		]),
	},

	methods: {
		...mapActions(useRootStore, ['show']),

		toggleFavorites() {
			this.showFavoritesOpen = !this.showFavoritesOpen
		},
	},
}
</script>

<style scoped lang="scss">
.page-list-favorites {
	border-bottom: 1px solid var(--color-border);

	.page-list-favorites-list {
		padding-left: 20px;
	}
}

.app-content-list-item {
	box-sizing: border-box;
	height: var(--default-clickable-area);
	margin-bottom: 4px;

	padding: 0;
	border-radius: var(--border-radius-large);

	&:hover, &:focus, &:active, &.highlight {
		background-color: var(--color-background-hover);

		span.item-icon-badge {
			background-color: var(--color-background-hover);
		}

		span.item-icon-favorite {
			background-color: var(--color-background-hover);
		}
	}

	.app-content-list-item-icon {
		display: flex;
		justify-content: center;
		align-items: center;

		.material-design-icon {
			cursor: pointer;
		}
	}

	.app-content-list-item-line-one {
		display: flex;
		padding-left: 40px;
	}

	.toggle-favorites-button {
		position: absolute;
		top: 0;
		right: 0;
		width: 34px;

		.collapsed {
			transition: transform var(--animation-slow);
			transform: rotate(-90deg);
		}
	}
}
</style>
