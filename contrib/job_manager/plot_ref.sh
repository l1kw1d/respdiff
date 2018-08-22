#!/bin/bash
set -o nounset

RESPDIFF_SRC=/var/opt/respdiff

COMMIT_DIR=${1:-.}
REF_COMMIT_DIR=${2:-../ref_current}
TEST_CASES=${3:-*}
pushd ${COMMIT_DIR}

ID=$(basename $(readlink -f ${PWD}))
REF_ID=$(basename $(readlink -f ${REF_COMMIT_DIR}))

for DIR in ${TEST_CASES}; do
    if [ -d "${DIR}" ]; then
        STATFILE=${REF_COMMIT_DIR}/${REF_ID}_${DIR}_stats.json
        if [ -r "${STATFILE}" ]; then
            ${RESPDIFF_SRC}/statcmp.py -s "${STATFILE}" -c "${DIR}/respdiff.cfg" ${DIR}/*_report.json -l ${ID}_vs_${REF_ID}_${DIR}
        else
            echo "${STATFILE} missing ... skipping"
        fi

        STATFILE=${REF_COMMIT_DIR}/${REF_ID}_${DIR}_stats.diffrepro.json
        if [ -r "${STATFILE}" ]; then
            ${RESPDIFF_SRC}/statcmp.py -s "${STATFILE}" -c "${DIR}/respdiff.cfg" ${DIR}/*_report.diffrepro.json -l ${ID}_vs_${REF_ID}_${DIR}.diffrepro
        else
            echo "${STATFILE} missing ... skipping"
        fi
    fi
done

popd
