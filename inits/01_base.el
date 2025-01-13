;;; -*- lexical-binding: t -*-

(setq ;; Do not make a backup file like *.~
 make-backup-files nil
 ;; Enable auto save
 auto-save-default t
 auto-save-list-file-prefix nil
 
 ;; Do not create lock file
 create-lockfiles nil
 ;; Open symbolic link directly
 vc-follow-symlinks t
 ;; Do not distinguish uppercase and lowercase letters on completion
 completion-ignore-case t
 read-file-name-completion-ignore-case  t
 ;; Point keeps its screen position when scroll
 scroll-preserve-screen-position  t
 ;; All warning sounds and flash are invalid
 ring-bell-function 'ignore
 ;; Turn off warning sound screen flash
 visible-bell nil
 ;; Deleted files go to the trash
 delete-by-moving-to-trash t
 ;; Tab width default
 tab-width 4
 ;; Use spaces instead of tabs
 indent-tabs-mode  nil
 ;; Limit the final word to a line break code (automatically correct)
 require-final-newline t

 ;; Disallow adding new lines with newline at the end of the buffer
 next-line-add-newlines nil
 sentence-end  "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
 sentence-end-double-space nil
 word-wrap-by-category t
 ;; Make it easy to see when it is the same name file
 uniquify-buffer-name-style 'post-forward-angle-brackets
 ;; It keeps going steadily the local mark ...  C-u C-SPC C-SPC
 ;; It keeps going steadily the global mark ... C-x C-SPC C-SPC
 set-mark-command-repeat-pop t
 ;; Make copy and paste use the same clipboard as emacs.
 select-enable-primary t
 select-enable-clipboard t)

;; Change to short command
(defalias 'yes-or-no-p #'y-or-n-p)
(defalias 'exit 'save-buffers-kill-emacs)

;; Encoding
(set-language-environment "English")
(prefer-coding-system 'utf-8)

;; Autorevert
(setq auto-revert-interval 0.1)
(add-hook 'after-init-hook 'global-auto-revert-mode)

;; Goto address
(add-hook 'prog-mode-hook 'goto-address-prog-mode)
