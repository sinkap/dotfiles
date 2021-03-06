#!/bin/bash

UPSTREAM_CONF_FILE="$( dirname "${BASH_SOURCE[0]}" )/upstream.conf"

function set-project()
{
	export UPSTREAM_PROJECT=${1:?"version (eg. v1) must be provided"}
}

function proj()
{
	source $UPSTREAM_CONF_FILE
	echo Working on "\"${UPSTREAM_STATE:?} ${UPSTREAM_VERSION:?}\"" of \
		"\"${UPSTREAM_PROJECT:?}\"" patch "\"${UPSTREAM_PATCH:?}\""
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
	source $UPSTREAM_CONF_FILE
	GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
	cd "${GIT_CHECKOUT:?}"
}

function goto-patches()
{
	source $UPSTREAM_CONF_FILE
	PATCHES_BASE="${HOME}/patches/${UPSTREAM_PATCH:?}"
	OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE// /_}/${UPSTREAM_VERSION:?}"

	if [[ ! -d ${OUTPUT_DIR:?} ]]; then
		echo "${OUTPUT_DIR:?} does not exist"
		echo "Looks like you have not run create-patches yet"
	else
		cd "${OUTPUT_DIR:?}"
	fi
}

function create-patches()
{
	(
		set -x
		source $UPSTREAM_CONF_FILE
		GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
		PATCHES_BASE="${HOME}/patches/${UPSTREAM_PATCH:?}"
		OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE// /_}/${UPSTREAM_VERSION:?}"
		REVISION=${1?"revision range must be providied"}

		if [[ -d ${OUTPUT_DIR:?} ]]; then
			read -p "${OUTPUT_DIR:?} already exists Overwrite? (y/n):" \
				choice

			case "$choice" in
			y|Y ) rm -rf ${OUTPUT_DIR:?};;
			n|N ) exit 1;;
			* ) echo "must be a y/n" || exit 1;;
			esac
		fi

		mkdir -p "${OUTPUT_DIR}"
		
		if [[ "${UPSTREAM_VERSION:?}" == "v1" ]]; then
			SUBJECT_PREFIX=${UPSTREAM_STATE:?}
		else
			SUBJECT_PREFIX="${UPSTREAM_STATE:?} ${UPSTREAM_VERSION:?}"
		fi

		cd "${GIT_CHECKOUT}" || exit 1

		if [[ "${REVISION:?}" == *".."* ]]; then
			NUM_COMMITS=`git rev-list --count "${REVISION?}"`
		else
			NUM_COMMITS=`git rev-list --count "${REVISION?}"..HEAD`
		fi

		if (($NUM_COMMITS > 1)); then
			if [[ "${NEED_COVER_LETTER:?}" == "y" ]]; then
				COVER_LETTER="--cover-letter"
			fi
		fi

		git format-patch --signoff $COVER_LETTER \
			--subject-prefix "${SUBJECT_PREFIX:?}" \
			-o "${OUTPUT_DIR}" \
			 "${REVISION?}"|| exit 1

		sed -i '/^Change-Id/d' ${OUTPUT_DIR}/* || exit 1


		echo "Checking patches..."
		scripts/checkpatch.pl "${OUTPUT_DIR}"/*
	)
}

function get-maintainers()
{
	(
		source $UPSTREAM_CONF_FILE
		GIT_CHECKOUT="${HOME}/projects/${UPSTREAM_PROJECT:?}"
		PATCHES_BASE="${HOME}/patches/${UPSTREAM_PATCH:?}"
		OUTPUT_DIR="${PATCHES_BASE:?}/${UPSTREAM_STATE// /_}/${UPSTREAM_VERSION:?}"

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
			--no-rolestats ${PATCH_FILES}
	)
}
