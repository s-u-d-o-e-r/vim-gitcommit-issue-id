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
      while 1
        let choice = inputlist(['1. Symantic release + Jira ID', '2. Jira ID', '3. None'])
        if choice == 0 || choice > 3
          redraw!
          echo 'Please enter a number between 1 and 3'
          continue
        elseif choice == 1
          call setline(1, 'feat(' . b:issue_id . '): ')
          call feedkeys("\<End>")
        elseif choice == 2
          call setline(1,  b:issue_id . ': ')
          call feedkeys("\<End>")
        endif
        break
      endwhile
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
