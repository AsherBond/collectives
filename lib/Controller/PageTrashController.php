<?php

declare(strict_types=1);

/**
 * SPDX-FileCopyrightText: 2023 Nextcloud GmbH and Nextcloud contributors
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

namespace OCA\Collectives\Controller;

use OCA\Collectives\Service\NotFoundException;
use OCA\Collectives\Service\PageService;
use OCP\AppFramework\Controller;
use OCP\AppFramework\Http\Attribute\NoAdminRequired;
use OCP\AppFramework\Http\DataResponse;
use OCP\IRequest;
use OCP\IUserSession;
use Psr\Log\LoggerInterface;

class PageTrashController extends Controller {
	private IUserSession $userSession;

	use ErrorHelper;

	public function __construct(
		string $appName,
		IRequest $request,
		private PageService $service,
		IUserSession $userSession,
		private LoggerInterface $logger,
	) {
		parent::__construct($appName, $request);
		$this->userSession = $userSession;
	}

	/**
	 * @throws NotFoundException
	 */
	private function getUserId(): string {
		$user = $this->userSession->getUser();
		if ($user === null) {
			throw new NotFoundException('Session user not found');
		}
		return $user->getUID();
	}

	#[NoAdminRequired]
	public function index(int $collectiveId): DataResponse {
		return $this->handleErrorResponse(function () use ($collectiveId): array {
			$userId = $this->getUserId();
			$pageInfos = $this->service->findAllTrash($collectiveId, $userId);
			return [
				'data' => $pageInfos
			];
		}, $this->logger);
	}

	#[NoAdminRequired]
	public function restore(int $collectiveId, int $id): DataResponse {
		return $this->handleErrorResponse(function () use ($collectiveId, $id): array {
			$userId = $this->getUserId();
			$pageInfo = $this->service->restore($collectiveId, $id, $userId);
			return [
				'data' => $pageInfo
			];
		}, $this->logger);
	}

	#[NoAdminRequired]
	public function delete(int $collectiveId, int $id): DataResponse {
		return $this->handleErrorResponse(function () use ($collectiveId, $id): array {
			$userId = $this->getUserId();
			$this->service->delete($collectiveId, $id, $userId);
			return [];
		}, $this->logger);
	}
}
