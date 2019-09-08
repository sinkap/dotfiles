#!/bin/bash

# defaults
UPSTREAM_PROJECT="krsi"
UPSTREAM_STATE="RFC"
UPSTREAM_VERSION="v1"



function set-project() 
{
	export UPSTREAM_PROJECT=${1:?"version (eg. v1) must be provided"}
}

function proj()
{
	echo Working on "\"${UPSTREAM_STATE:?} ${UPSTREAM_VERSION:?}\"" of \
		"\"${UPSTREAM_PROJECT:?}\""
}

function set-project-state()
{
	export UPSTREAM_STATE=${1:?"state i.e. RFC/PATCH must be provided"}
}

function set-project-version()
{
	export UPSTREAM_VERSION=${1:?"version (eg. v1) must be provided"}
}

function goto-proj()
{
	GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
	cd "${GIT_CHECKOUT:?}"
}

function goto-patches()
{
	PATCHES_BASE="${HOME}/patches/${UPSTREAM_PROJECT:?}"
	OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE:?}/${UPSTREAM_VERSION:?}"

	if [[ ! -d ${OUTPUT_DIR:?} ]]; then
		echo "${OUTPUT_DIR:?} does not exist"
		echo "Looks like you have not run create-patches yet"
	else
		cd "${PATCHES_BASE:?}"
	fi
}

function create-patches()
{
	(
		GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
		PATCHES_BASE="${HOME}/patches/${UPSTREAM_PROJECT:?}"
		OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE:?}/${UPSTREAM_VERSION:?}"

		if [[ -d ${OUTPUT_DIR:?} ]]; then
			read -p "${OUTPUT_DIR:?} already exists Overwrite? (y/n)", \
				choice

			case "$choice" in
			y|Y ) rm -rf ${OUTPUT_DIR:?};;
			n|N ) exit 1;;
			* ) echo "must be a y/n" || exit 1;;
			esac
		fi

		mkdir -p "${OUTPUT_DIR}"

		cd "${GIT_CHECKOUT}" || exit 1
		git format-patch --signoff \
			--cover-letter \
			--subject "${UPSTREAM_STATE:?} ${UPSTREAM_VERSION:?}" \
			--output "${OUTPUT_DIR}" \
			 ${1?"revision range must be providied"} || exit 1

		sed -i '/^Change-Id/d' ${OUTPUT_DIR}/* || exit 1

		if [[ -f ${GIT_CHECKOUT}/scripts/checkpatch.pl ]]; then
			echo "Checking patches..."
			${GIT_CHECKOUT}/scripts/checkpatch.pl "${OUTPUT_DIR}"/*
		fi
	)
}

function get-maintainers()
{
	(
		GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
		PATCHES_BASE="${HOME}/patches/${UPSTREAM_PROJECT:?}"
		OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE:?}/${UPSTREAM_VERSION:?}"


		if [[ ! -f ${GIT_CHECKOUT}/scripts/get_maintainer.pl ]]; then
			echo "Project: ${UPSTREAM_PROJECT:?} is not a kernel project"
			exit 1
		fi

		if [[ ! -d ${OUTPUT_DIR:?} ]]; then
			echo "${OUTPUT_DIR:?} does not exist"
			echo "Looks like you have not run create-patches yet"
			exit 1
		fi

		cd "${GIT_CHECKOUT}" || exit 1
		PATCH_FILES=$(ls "${OUTPUT_DIR}"/* | grep -v cover-letter)

		${GIT_CHECKOUT}/scripts/get_maintainer.pl \
			--separator="," \
			--no-rolestats ${PATCH_FILES}
	)
}