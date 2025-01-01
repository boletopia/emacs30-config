;;; 00_base.el --- Basic configurations. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package emacs
  :custom
  ;; No startup screen appears
  (inhibit-splash-screen  t)
  ;; Faster rendering by not corresponding to right-to-left language
  (bidi-display-reordering  nil)
  ;; Do not make a backup file like *.~
  (make-backup-files  nil)
  ;; Enable auto save
  (auto-save-default  t)
  (auto-save-list-file-prefix  nil)
  ;; Do not create lock file
  (create-lockfiles  nil)
  ;; Open symbolic link directly
  (vc-follow-symlinks  t)
  ;; Split frame vertically
  (when is-gui
    (split-width-threshold  0)
    (split-height-threshold  nil))
  ;; Do not distinguish uppercase and lowercase letters on completion
  (completion-ignore-case  t)
  (read-file-name-completion-ignore-case  t)
  ;; Point keeps its screen position when scroll
  (scroll-preserve-screen-position  t)
  ;; All warning sounds and flash are invalid
  (ring-bell-function  'ignore)
  ;; Turn off warning sound screen flash
  (visible-bell  nil)
  ;; Copy text with mouse range selection
  (mouse-drag-copy-region  t)
  ;; Deleted files go to the trash
  (delete-by-moving-to-trash  t)
  ;; Tab width default
  (tab-width  4)
  ;; Use spaces instead of tabs
  (indent-tabs-mode   nil)
  ;; Limit the final word to a line break code (automatically correct)
  (require-final-newline  t)
  ;; Disallow adding new lines with newline at the end of the buffer
  (next-line-add-newlines  nil)
  (sentence-end  "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
  (sentence-end-double-space  nil)
  (word-wrap-by-category  t)
  ;; Make it easy to see when it is the same name file
  (uniquify-buffer-name-style  'post-forward-angle-brackets)
  ;; It keeps going steadily the local mark ...  C-u C-SPC C-SPC
  ;; It keeps going steadily the global mark ... C-x C-SPC C-SPC
  (set-mark-command-repeat-pop  t)
  ;; Use the X11 clipboard
  (select-enable-clipboard   t)
  ;; change-default-file-location
  (request-storage-directory  (expand-file-name "tmp/request" user-emacs-directory))
  (url-configuration-directory  (expand-file-name "tmp/url" user-emacs-directory))
  (bookmark-file  (expand-file-name "tmp/bookmark" user-emacs-directory))

  :config

  ;; Share PATH from shell environment variables
  ;; Disabling this because it is taking 900+ ms to load
  (use-package exec-path-from-shell :ensure t
    :init
    (setenv "SHELL" "/bin/zsh")
    :if (memq window-system '(mac ns x))
    :config
    (setq exec-path-from-shell-variables '("PATH" "GOPATH" "PYTHONPATH"))
    (exec-path-from-shell-initialize))

  ;; Always clean white space
  (use-package ws-butler :ensure t
    :hook ((text-mode . ws-butler-mode)
           (prog-mode . ws-butler-mode)))

  ;; Change to short command
  (defalias 'yes-or-no-p #'y-or-n-p)
  (defalias 'exit 'save-buffers-kill-emacs)

  ;; Encoding
  (set-language-environment "English")
  (prefer-coding-system 'utf-8)

  ;; Recentf
  (setq recentf-auto-cleanup 'never)
  (setq recentf-exclude
		'("\\.howm-keys" "Dropbox/backup" ".emacs.d/tmp/" ".emacs.d/elpa/" "/scp:"))
  (setq recentf-save-file (expand-file-name "tmp/recentf" user-emacs-directory))
  (add-hook 'after-init-hook 'recentf-mode)

  ;; Autorevert
  (setq auto-revert-interval 0.1)
  (add-hook 'after-init-hook 'global-auto-revert-mode)

  ;; Goto address
  (add-hook 'prog-mode-hook 'goto-address-prog-mode)

  ;; Recovery
  (setq save-place-file (expand-file-name "tmp/places" user-emacs-directory))
  (add-hook 'after-init-hook 'save-place-mode)

  ;; Savehist
  (setq savehist-file (expand-file-name "tmp/history" user-emacs-directory))
  (setq savehist-additional-variables '(kill-ring))
  (add-hook 'after-init-hook 'savehist-mode)

  ;; Emacs init time
  (defun ad:emacs-init-time ()
	"Advice `emacs-init-time'."
	(interactive)
	(let ((str
		   (format "%.3f seconds"
				   (float-time
					(time-subtract after-init-time before-init-time)))))
	  (if (called-interactively-p 'interactive)
		  (message "%s" str)
		str)))

  (advice-add 'emacs-init-time :override #'ad:emacs-init-time)

  ;; Display it in message
  (add-hook 'emacs-startup-hook
		    (lambda()
			  (message "***Emacs loaded in %s."
					   (emacs-init-time))))

  ;; line numbersr
  (column-number-mode)

  ;; Enable line numbers for some modes
  (dolist (mode '(text-mode-hook
                  prog-mode-hook
                  conf-mode-hook))
    (add-hook mode (lambda () (display-line-numbers-mode 1)))))

;; Restart emacs from within
(use-package restart-emacs :ensure t
  :straight '(restart-emacs
              :type git
              :host github
              :repo "iqbalansari/restart-emacs"))


;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 00_base.el ends here
