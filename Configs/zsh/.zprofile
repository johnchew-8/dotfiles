# Login shells only
# path_helper moves user paths behind system paths, so reorder them to the front.
(( $+functions[_dotfiles_path] )) && _dotfiles_path
