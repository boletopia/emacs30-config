;; 02_git.el  --- Git configurations. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-erro t)

(use-package diff-hl :ensure t
  :hook
  ((after-init-hook . global-diff-hl-mode)
   (after-init-hook . diff-hl-margin-mode)
   (magit-pre-refresh-hook .diff-hl-magit-pre-refresh)
   (magit-post-refresh-hook . diff-hl-magit-post-refresh)))

(use-package hydra
  :ensure t)

(use-package magit :ensure t
  :bind (("C-x g" . magit-status))  
  :custom
  `((transient-history-file . (expand-file-name "tmp/transient-history" user-emacs-directory))

	;; Do not split window
	(magit-display-buffer-function . 'magit-display-buffer-fullframe-status-v1))
  
  :config
  (defhydra hydra-git  (:color red :hint nil)
    "
    magit: _s_tatus  _b_lame  _c_heckout  _l_og  _g_itk  _t_imemachine
   "
    ("s" magit-status)
    ("b" magit-blame-addition)
    ("c" magit-file-checkout)
    ("l" magit-log-buffer-file)
    ("g" gitk-open)
    ("t" git-timemachine-toggle)
    ("<muhenkan>" nil))
  
  ;; Bind the hydra to a key if desired
  (global-set-key (kbd "C-c g") 'hydra-git/body)
  
  (use-package git-timemachine	:ensure t)
  (use-package browse-at-remote :ensure t
	:custom	(browse-at-remote-prefer-symbolic . nil))

  (defun gitk-open ()
	"Open gitk with current dir.
see https://riptutorial.com/git/example/18336/gitk-and-git-gui"
	(interactive)
	(shell-command "gitk &")
	(delete-other-windows))

  (defun git-gui-open ()
	"Tools for creating commits."
	(interactive)
	(shell-command "git gui &")
	(delete-other-windows))
  )

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 02_git.el ends here
