#!/bin/bash

set -euo pipefail

readonly results_dir="$1"
readonly majority_dir="$2"
readonly consensus_dir="$3"
readonly query_dir="$4"
readonly query="$(basename "$query_dir")"

. src/shared.sh

all_implementations_and_proposals() {
    find ./implementations -name run.sh -maxdepth 2 -print0 | xargs -0 -n1 dirname | xargs -n1 basename | sort
    find ./proposals -name run.sh -maxdepth 2 -print0 | xargs -0 -n1 dirname | xargs -n1 basename | sort
}

is_in_majority() {
    local implementation="$1"
    tail -n +4 < "${majority_dir}/${query}" | grep "^${implementation}\$" > /dev/null
}

has_consensus() {
    test -s "${consensus_dir}/${query}"
}

is_outlier() {
    local implementation="$1"
    is_query_result_ok "${results_dir}/${query}/${implementation}" && (! has_consensus || ! is_in_majority "$implementation")
}

implementation_outliers() {
    local implementation
    while IFS= read -r implementation; do
        if is_outlier "$implementation"; then
            echo "$implementation"
        fi
    done <<< "$(all_implementations_and_proposals)"
}

implementation_errors() {
    local implementation
    while IFS= read -r implementation; do
        if ! is_query_result_ok "${results_dir}/${query}/${implementation}"; then
            echo "$implementation"
        fi
    done <<< "$(all_implementations_and_proposals)"
}

output_setup() {
    local selector_file="$query_dir"/selector
    local document="$query_dir"/document.json
    local selector
    selector="$(cat "${selector_file}")"

    echo "Selector: \`${selector}\`"
    echo

    pre_block < "$document"
}

consensus() {
    local line

    grep '^consensus' < "${consensus_dir}/${query}" | cut -f2 | ./src/pretty_json.py | pre_block

    while IFS= read -r line; do
        if [[ -z "$line" ]]; then
            break
        fi

        echo "<h4>"
        cut -f1 <<< "$(capitalize "$line")" | tr '-' ' '
        echo "</h4>"
        echo
        cut -f2 <<< "$line" | pre_block
    done <<< "$(grep -v '^consensus' < "${consensus_dir}/${query}")"
}

main() {
    local implementation
    local outliers
    local errors

    echo "# $(pretty_query_name "$query")"
    echo

    echo "## Setup"
    output_setup
    echo

    echo "## Results"

    if has_consensus; then
        echo '<h3 id="consensus">Consensus</h3>'
        echo
        consensus
        echo
    fi

    outliers="$(implementation_outliers)"

    if [[ -n "$outliers" ]]; then
        echo "### Other responses"
        echo

        while IFS= read -r implementation; do
            echo "<h4 id=\"$implementation\">"
            pretty_implementation_name "$implementation"
            echo "</h4>"
            echo
            query_result_payload "${results_dir}/${query}/${implementation}" | ./src/pretty_json.py | pre_block
            echo
        done <<< "$outliers"
    fi

    errors="$(implementation_errors)"

    if [[ -n "$errors" ]]; then
        echo "### Errors"
        echo

        while IFS= read -r implementation; do
            echo "<h4 id=\"$implementation\">"
            pretty_implementation_name "$implementation"
            echo "</h4>"
            echo
            query_result_payload "${results_dir}/${query}/${implementation}" | pre_block
            echo
        done <<< "$errors"
    fi
}

main
