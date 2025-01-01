;;; 10_org.el --- Org mode configurations.
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package org :ensure t

  :bind
  (("C-c a" . org-agenda)
   ("C-c c" . org-capture)
   ("C-c k" . org-capture-kill)
   ("M-q" . compact-uncompact-block))

  :config

  ;; Startup
  (setq org-startup-folded 'content)
  (setq org-startup-truncated nil)
  (setq org-startup-indented t)
  (setq org-hide-block-startup nil)

  ;; Edit settings
  (setq org-auto-align-tags nil)
  (setq org-tags-column 0)
  (setq org-catch-invisible-edits 'show-and-error)
  (setq org-special-ctrl-a/e t)
  (setq org-insert-heading-respect-content t)
  (setq org-src-tab-acts-natively t)
  (setq org-edit-src-content-indentation 2)
  (setq org-src-preserve-indentation nil)
  (setq org-directory (concat (getenv "HOME") "/org-roam"))
  (setq org-default-notes-file
        (concat org-directory "/agenda.org"))
  (setq org-agenda-files
        (append (list (concat org-directory "/agenda.org"))))

  (setq org-todo-keywords
        '((sequence "NOW" "LATER" "VERIFY" "|" "DONE" "DELEGATED")))

  (setq org-capture-templates
        '(("d" "Todo" entry (file+headline org-default-notes-file "Quick tasks")
           "* LATER %?\n  %i\n  %a")

          ("t" "Thoughts" entry (file+headline org-default-notes-file "Thoughts for a project")
           "* %?\n  %i\n  %a")))

  ;; Org styling, hide markup etc.
  ;; (org-indent-mode)
  (setq org-ellipsis "...")
  (setq org-hide-emphasis-markers t)
  (setq org-pretty-entities t)
  (setq org-src-fontify-natively t)
  (setq org-fontify-quote-and-verse-blocks t)
  (setq org-display-remote-inline-images t)
  (setq org-display-inline-images t)
  (setq org-image-actual-width 400)
  (setq org-inline-image-background "white")
  (setq org-cycle-separator-lines 2)

  ;; Agenda styling
  (setq org-agenda-tags-column 0)
  (setq org-agenda-block-separator ?─)
  (setq org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄"))
  (setq  org-agenda-current-time-string
         "◀── now ─────────────────────────────────────────────────")

  ;; Some configs to utilize the clocking feature
  ;; Insert only timestamp when closing an org TODO item
  (setq org-log-done 'time)
  (setq org-use-speed-commands t)

  (setq org-refile-targets '((nil :maxlevel . 1)
                             (org-agenda-files :maxlevel . 1)))

  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
  (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
  (add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
  (add-to-list 'org-structure-template-alist '("py" . "src python :results result"))
  (add-to-list 'org-structure-template-alist '("pyg" . "src python :results file :var f= :return f
  plt.savefig(f)
  plt.clf()"))
  (add-to-list 'org-structure-template-alist '("r" . "src R :results output"))
  (add-to-list 'org-structure-template-alist '("go" . "src go"))
  (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
  (add-to-list 'org-structure-template-alist '("toml" . "src toml"))
  (add-to-list 'org-structure-template-alist '("json" . "src json"))
  (add-to-list 'org-structure-template-alist '("scala" . "src scala"))
  (add-to-list 'org-structure-template-alist '("sql" . "src sql"))
  (add-to-list 'org-structure-template-alist '("gql" . "src graphql"))


  ;; Update a last_modified timestamp
  ;; https://github.com/zaeph/.emacs.d/blob/4548c34d1965f4732d5df1f56134dc36b58f6577/init.el#L2822-L2875
  (defun zp/org-find-time-file-property (property &optional anywhere)
    "Return the position of the time file PROPERTY if it exists.
    When ANYWHERE is non-nil, search beyond the preamble."
    (save-excursion
      (goto-char (point-min))
      (let ((first-heading
             (save-excursion
               (re-search-forward org-outline-regexp-bol nil t))))
        (when (re-search-forward (format "^#\\+%s:" property)
                                 (if anywhere nil first-heading)
                                 t)
          (point)))))

  (defun zp/org-has-time-file-property-p (property &optional anywhere)
    "Return the position of time file PROPERTY if it is defined.
    As a special case, return -1 if the time file PROPERTY exists but
    is not defined."
    (when-let ((pos (zp/org-find-time-file-property property anywhere)))
      (save-excursion
        (goto-char pos)
        (if (and (looking-at-p " ")
                 (progn (forward-char)
                        (org-at-timestamp-p 'lax)))
            pos
          -1))))

  (defun zp/org-set-time-file-property (property &optional anywhere pos)
    "Set the time file PROPERTY in the preamble.
    When ANYWHERE is non-nil, search beyond the preamble.
    If the position of the file PROPERTY has already been computed,
    it can be passed in POS."
    (when-let ((pos (or pos
                        (zp/org-find-time-file-property property))))
      (save-excursion
        (goto-char pos)
        (if (looking-at-p " ")
            (forward-char)
          (insert " "))
        (delete-region (point) (line-end-position))
        (let* ((now (format-time-string "[%Y-%m-%d %a %H:%M]")))
          (insert now)))))

  (defun zp/org-set-last-modified ()
    "Update the LAST_MODIFIED file property in the preamble."
    (when (derived-mode-p 'org-mode)
      (zp/org-set-time-file-property "last_modified")))

  (add-hook 'before-save-hook #'zp/org-set-last-modified)

  ;; Make bold with highlight text background.
  (setq org-emphasis-alist
        '(("*" (bold :background "yellow" :foreground "dim gray"))
          ("/" (italic :background "plum" :foreground "white smoke"))
          ("_" (underline :background "pale green" :foreground "dim gray"))
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" (:strike-through t))))

  (use-package org-appear :ensure t
    :config
    (add-hook 'org-mode-hook 'org-appear-mode))


  ;; http://xahlee.org/emacs/modernization_fill-paragraph.html
  (defun compact-uncompact-block ()
    "Remove or add line endings on the current block of text.
This is similar to a toggle for fill-paragraph and unfill-paragraph
When there is a text selection, act on the region.

When in text mode, a paragraph is considered a block. When in programing
language mode, the block defined by between empty lines.

Todo: The programing language behavior is currently not done.
Right now, the code uses fill* functions, so does not work or work well
in programing lang modes. A proper implementation to compact is replacing
newline chars by space when the newline char is not inside string.
"
    (interactive)
    (let (bds currentLineCharCount currentStateIsCompact
              (bigFillColumnVal 4333999) (deactivate-mark nil))
      (save-excursion
        (setq currentLineCharCount
              (progn
                (setq bds (bounds-of-thing-at-point 'line))
                (length (buffer-substring-no-properties (car bds) (cdr bds)))))
        (setq currentStateIsCompact
              (if (eq last-command this-command)
                  (get this-command 'stateIsCompact-p)
                (if (> currentLineCharCount fill-column) t nil)))
        (if (and transient-mark-mode mark-active)
            (if currentStateIsCompact
                (fill-region (region-beginning) (region-end))
              (let ((fill-column bigFillColumnVal))
                (fill-region (region-beginning) (region-end)))
              )
          (if currentStateIsCompact
              (fill-paragraph nil)
            (let ((fill-column bigFillColumnVal))
              (fill-paragraph nil))))
        (put this-command 'stateIsCompact-p
             (if currentStateIsCompact
                 nil t)))))

  ;; (global-set-key (kbd "M-q") 'compact-uncompact-block)

  ;; enable export to markdown
  (eval-after-load "org"
    '(require 'ox-md nil t))

  ;; This ends the use-package org-mode block
  )



;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 10_org.el ends here
