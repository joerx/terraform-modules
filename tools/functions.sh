col_rst="\e[0m"
col_red="\e[31m"
col_green="\e[32m"
col_yellow="\e[33m"

# List modules in given path. Any directory incuding the path itself that contain *.tf files will be regarded.
function list_modules_in_path() {
    _pushd ${1}
    find . -type f -name '*.tf' -not -path */.terraform/* | xargs -n1 dirname | sort | uniq | sed s@^./@@
    _popd
}

# List changed modules in git diff to master. Only added/changed/copied/renamed files will be regarded
function list_changed_modules_in_diff() {
    set +o pipefail
    local branch=${1}
    git diff ${branch} --diff-filter=ACMR --name-only | xargs -n1 dirname | sort | uniq
    set -o pipefail
}

function get_module_version() {
    head -n1 ${1}/VERSION
}

function log_line() {
    >&2 echo "---"
}

function log_debug() {
    [[ -z $YIO_DEBUG ]] && return
    >&2 printf "${@}\n"
}

function log_info() {
    >&2 printf "Info: ${@}\n"
}

function log() {
    >&2 printf "${@}\n"
}

function log_success() {
    >&2 printf "${col_green}Success: ${@}${col_rst}\n"
}

function log_pass() {
    >&2 printf "${col_green}Pass:  ${@}${col_rst}\n"
}

function log_warn() {
    >&2 printf "${col_yellow}Warn:  ${@}${col_rst}\n"
}

function log_error() {
    >&2 printf "${col_red}Error: ${@}${col_rst}\n"
}

function fail() {
    log_error "${@}"
    exit 1
}

function _pushd() {
    pushd > /dev/null $@
}

function _popd() {
    popd > /dev/null
}

function _abspath() {
    echo $(cd ${1} && pwd)
}
