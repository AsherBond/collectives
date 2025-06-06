/**
 * SPDX-FileCopyrightText: 2025 Nextcloud GmbH and Nextcloud contributors
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

/**
 * DAV Request data for listing versions
 *
 * @return {string}
 */
export function listVersions() {
	return `<?xml version="1.0"?>
<d:propfind xmlns:d="DAV:"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns"
	xmlns:ocs="http://open-collaboration-services.org/ns">
	<d:prop>
		<d:getcontentlength />
		<d:getcontenttype />
		<d:getlastmodified />
		<d:getetag />
		<nc:version-label />
		<nc:version-author />
		<nc:has-preview />
	</d:prop>
</d:propfind>`
}

/**
 * DAV Request data for setting a version label
 *
 * @param {string} label - Label to set
 * @return {string}
 */
export function setLabel(label) {
	return `<?xml version="1.0"?>
<d:propertyupdate xmlns:d="DAV:"
	xmlns:oc="http://owncloud.org/ns"
	xmlns:nc="http://nextcloud.org/ns"
	xmlns:ocs="http://open-collaboration-services.org/ns">
	<d:set>
		<d:prop>
			<nc:version-label>${label}</nc:version-label>
		</d:prop>
	</d:set>
</d:propertyupdate>`
}
