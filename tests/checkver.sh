#!/bin/sh

set -eu

# Support any invocation of/with shunit2
if [ "${0}" = "${0%%'shunit2'}" ]; then
	"$(command -v shunit2)" "${0}"
	return "${?}"
fi
src_dir="${1%%"${1##*'/'}"}"
COMMAND_UNDER_TEST="${COMMAND_UNDER_TEST:-${src_dir}/../${1##*'/'}}"
shift

set +eu

testBasic()
{
	ver="1.0.0"
	req="1.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.999.999"
	req="1.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.999.999"
	req="2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="1.999.999"
	req="2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}

testExact()
{
	ver="2.0.0"
	req="=2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="2.0.1"
	req="=2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="1.999.999"
	req="=2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}

testGreaterThan()
{
	ver="2.0.1"
	req=">2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="2.0.0"
	req=">2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="2.1.0"
	req=">2.1.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="2.1.1"
	req=">2.2.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

}

testLessThan()
{
	ver="1.99.99"
	req="<2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.99.99"
	req="<2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	ver="2.1.99"
	req="<2.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="2.0.0"
	req="<2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="2.1.0"
	req="<2.1.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"

	ver="2.2.1"
	req="<2.2.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}

testTilde()
{
	ver="1.1.1"
	req="~1"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.1"
	req="~1.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.2"
	req="~1.2.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="0.9.1"
	req="~1.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}

testCaret()
{
	ver="1.1.1"
	req="^1"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.1"
	req="^1.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.2"
	req="^1.2.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="0.9.1"
	req="^1.2"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}

testMultiple()
{
	ver="1.1.1"
	req=">=1.1.1, <1.2.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.1"
	req=">1.2.0, <=1.2.1"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.1"
	req=">1.1, <=1.2.1"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="1.2.2"
	req=">1.2.0, <2.0.0"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should fulfill requirement ${req}" "[ ${?} -eq 0 ]"

	ver="0.9.1"
	req=">0.9, <0.9"
	"${COMMAND_UNDER_TEST}" \
	                        "${ver}" "${req}"

	assertTrue "Version ${ver} should not fulfill requirement ${req}" "[ ${?} -ne 0 ]"
}
