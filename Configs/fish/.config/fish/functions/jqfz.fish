function jqfz --description 'Interactive jq JSON explorer with fzf' --argument-names file_path
    if not test -f "$file_path"
        echo "jqfz: file not found: $file_path" >&2
        return 1
    end

    set -f safe_path (string escape -- $file_path)

    set -f selected_path (
      jq -r 'paths(scalars) as $p | [$p | join("."), ($p | @json)] | @tsv' "$file_path" | \
      _fzf_wrapper --delimiter="\t" --with-nth=1 \
      --preview "jq -C --argjson p {2} 'getpath(\$p)' $safe_path" \
      --prompt="jq> " \
      --header="Ctrl-C to abort, Enter to select"
    )

    set -f fzf_status $status
    if test $fzf_status -ne 0
        return $fzf_status
    end

    set -f json_path (string split --field 2 \t "$selected_path")
    jq -r --argjson p "$json_path" 'getpath($p)' "$file_path"
end
