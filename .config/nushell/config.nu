# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings,
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

$env.config.show_banner = false
$env.config.buffer_editor = "nvim"

alias builtin-ls = ls
alias vim = nvim
alias v = nvim

def cat [file: path] {
    open $file
}

def ls [
    --all (-a),         # Show hidden files
    --long (-l),        # Get all available columns for each entry (slower; columns are platform-dependent)
    --short-names (-s), # Only print the file names, and not the path
    --full-paths (-f),  # Display paths as absolute paths
    --du (-d),          # Display the apparent directory size ("disk usage") in place of the directory metadata size
    --directory (-D),   # List the specified directory itself instead of its contents
    --mime-type (-m),   # Show mime-type in type column instead of 'file' (based on filenames only; files' contents are not examined)
    --threads (-t),     # Use multiple threads to list contents. Output will be non-deterministic.
    ...pattern: glob,   # The glob pattern to use.
]: [ nothing -> table ] {
    let pattern = if ($pattern | is-empty) { [ '.' ] } else { $pattern }
    (builtin-ls
        --all=$all
        --long=$long
        --short-names=$short_names
        --full-paths=$full_paths
        --du=$du
        --directory=$directory
        --mime-type=$mime_type
        --threads=$threads
        ...$pattern
    ) | sort-by type name -i
}
alias ll = ls
alias la = ls -a

# Cross-platform `ln` command, hardlink by default, -s for symbolic
def ln [
    target: path       # The file or directory to link to
    link_name: path    # The name for the link
    --symbolic(-s)     # Create a symbolic link instead of a hard link
] {
    let target_path = ($target | path expand)
    let link_path = ($link_name | path expand)

    if (not $symbolic) and (not ($target_path | path exists)) {
        error make { msg: $"ln: failed to access '($target)': No such file or directory" }
    }
    if (not $symbolic) and ($target_path | path type) == "dir" {
        error make { msg: $"ln: '($target)': hard link not allowed for directory" }
    }
    if ($link_path | path exists) {
        error make { msg: $"ln: failed to create link '($link_name)': File exists" }
    }

    match $nu.os-info.name {
        "windows" => {
            if $symbolic {
                if ($target_path | path exists) and ($target_path | path type) == "dir" {
                    ^mklink /D $link_path $target_path
                } else {
                    ^mklink $link_path $target_path
                }
            } else {
                ^mklink /H $link_path $target_path
            }
        }
        _ => {
            # Linux, macOS, and other Unix-like systems
            if $symbolic {
                ^ln -s $target_path $link_path
            } else {
                ^ln $target_path $link_path
            }
        }
    }
}

def ldd [file: path] {
    match $nu.os-info.name {
        "windows" => {
            ^llvm-objdump -p $file
            | lines
            | find "DLL Name"
            | sort
            | str replace -r '.*: ' ''
            | str join (char nl)
        }
        _ => {
            ^ldd $file
        }
    }
}

# init starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
