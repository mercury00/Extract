#!/bin/bash
# function Extract for common file formats

function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for archive in "${@}"
    do
      if [ -f "$archive" ] ; then
          case "${archive%,}" in
            *.tar.bz2|*.tbz2)
                         tar --bzip2 -xvf "$archive" ;;
            *.tar.gz|*.tgz)
                         tar --gunzip -xvf "$archive" ;;
            *.tar.xz|*.txz)
                         tar --xz -xvf "$archive" ;;
            *.tar)       tar -xvf "$archive"      ;;
            *.lzma)      unlzma ./"$archive"      ;;
            *.bz2)       bunzip2 ./"$archive"     ;;
            *.rar)       unrar x -ad ./"$archive" ;;
            *.gz)        gunzip ./"$archive"      ;;
            *.zip)       unzip ./"$archive"       ;;
            *.z)         uncompress ./"$archive"  ;;
            *.xz)        unxz --keep ./"$archive"        ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$archive"        ;;
            *.exe)       cabextract ./"$archive"  ;;
            *)
                suf=${archive##*.}
                filetype=$(file --mime-type -b $archive); filetype=${filetype#application/}
                # TODO: add 7zip, arj, cab, chm, deb, dmg, iso, lzh, msi, rpm, udf, wim, xar"
                case "${filetype}" in
                  'text/plain')
                                 echo "ASCII text is not extractable"
                                 return 1                                   ;;
                  'inode/x-empty')
                                 echo "empty files are not extractable"
                                 return 1                                   ;;
                  'x-tar')       tar -xvf "$archive"                        ;;
                  'x-bzip2')     bunzip2 ./"$archive"                       ;;
                  'x-xz')        unxz --keep --suffix="${suf}" ./"$archive" ;;
                  'gzip')        gunzip ./"$archive"                        ;;
                  'x-lzip')      unlzma ./"$archive"                        ;;
                  'x-compress')  uncompress ./"$archive"                    ;;
                  'x-rar')       unrar x -ad ./"$archive"                   ;;
                  *)
                      echo "extract: '${n}' - unknown archive method, file is '${filetype}'"
                      return 1
                      ;;
                esac
                ;;
          esac
      else
          echo "'$n' - not a regular file"
          return 1
      fi
    done
fi
}
export -f extract
