" File:          gitcommit.vim
" Description:   Add JIRA issue ID to git commit messages

if exists('b:loaded_gitcommit_issue_id')
    finish
endif
let b:loaded_gitcommit_issue_id = 1

function! s:InsertIssueId()
  if getline(1) == ''
    let l:branch = system("git rev-parse --abbrev-ref HEAD")
    let b:issue_id = matchstr(branch, '\([^-/]\+-\d\+\)')
    if !empty(b:issue_id)
      echom 'Choose template:'
      let useTemplate= confirm("Do you want to use template?", "&Yes\n&No", 2)

      if useTemplate == 1
      let template= confirm("Choose template:", "&Jira ID\n&Semantic Jira ID", 1)
        if template == 1
          call setline(1,  b:issue_id . ': ')
          call feedkeys("\<End>")


        elseif template==2
          let semanticTemplate= confirm("Choose type:", "&feat\nfi&x\n&refactor\n&perf\n&test\n&build\n&docs\n&ci", 1)

          if semanticTemplate == 1
            call setline(1, 'feat(' . b:issue_id . '): ')
          elseif semanticTemplate ==2
            call setline(1, 'fix(' . b:issue_id . '): ')
          elseif semanticTemplate ==3
            call setline(1, 'refactor(' . b:issue_id . '): ')
          elseif semanticTemplate ==4
            call setline(1, 'perf(' . b:issue_id . '): ')
          elseif semanticTemplate ==5
            call setline(1, 'test(' . b:issue_id . '): ')
          elseif semanticTemplate ==6
            call setline(1, 'build(' . b:issue_id . '): ')
          elseif semanticTemplate ==7
            call setline(1, 'docs(' . b:issue_id . '): ')
          elseif semanticTemplate ==8
            call setline(1, 'ci(' . b:issue_id . '): ')
          endif

          call feedkeys("\<End>")
        endif
      endif
    endif
  endif
endfunction

function! s:EnsureCommitMsg()
  if exists('b:issue_id') && getline(1) == b:issue_id . ': '
    cquit
  endif
endfunction

call s:InsertIssueId()

augroup gitcommit_issue_id
  autocmd BufUnload <buffer> call s:EnsureCommitMsg()
augroup END
