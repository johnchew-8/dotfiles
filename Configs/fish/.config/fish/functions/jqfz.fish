function jqfz --description 'Interactive jq JSON explorer with fzf' --argument-names file_path
    if not test -f "$file_path"
        echo "jqfz: file not found: $file_path" >&2
        return 1
    end

    set -f safe_path (string escape -- $file_path)

    # Detect JSONC files -strip // , /**/ comment line before jq processing
    set -f json_input "$file_path"
    if string match --quiet '*.jsonc' "$file_path"
        set json_input (sed 's|//.*||' "$safe_path" | psub)
    end

    set -f selected_path (
      jq -r 'paths(scalars) as $p | [$p | join("."), ($p | @json)] | @tsv' "$file_path" | \
      _fzf_wrapper --delimiter= '\t' --with-nth=1 \
      --preview "jq -C 'getpath({2} | fromjson)' $safe_path" \
      --prompt="jq> " \
      --header="Ctrl-C to abort, Enter to select"
    )

    set -f fzf_status $status
    if test $fzf_status -ne 0
        return $fzf_status
    end

    set -f json_path (string split --field 2 \t "$selected_path")
    jq -r "getpath($json_path | fromjson)" $json_input
end
