;;; -*- lexical-binding: t -*-

;; Configure general orgmode usage
(setq-default org-directory "~/Documents/org"
              org-ellipsis " …"              ; Nicer ellipsis
              org-tags-column 1              ; Tags next to header title
              org-hide-emphasis-markers t    ; Hide markers
              org-cycle-separator-lines 2    ; Number of empty lines between sections
	      org-catch-invisible-edits 'show-and-error ; Check if in invisible region before edit
              org-use-tag-inheritance nil    ; Tags ARE NOT inherited 
              org-use-property-inheritance t ; Properties ARE inherited
              org-indent-indentation-per-level 2 ; Indentation per level
              org-link-use-indirect-buffer-for-internals t ; Indirect buffer for internal links
              org-fontify-quote-and-verse-blocks t ; Specific face for quote and verse blocks
              org-return-follows-link nil    ; Follow links when hitting return
              org-image-actual-width nil     ; Resize image to window width
              org-indirect-buffer-display 'other-window ; Tab on a task expand it in a new window
              org-outline-path-complete-in-steps nil) ; No steps in path display

;; Soft wrap
(global-visual-line-mode 1)

;; https://codeberg.org/joostkremers/visual-fill-column
;; "mimics the effect of fill-column in visual-line-mode. I use it to achieve fill-column in org mode"
(use-package visual-fill-column
  :config
  (defun yx-func/org-mode-visual-fill ()
    (setq visual-fill-column-width 110
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1))
  (add-hook 'org-mode-hook #'yx-func/org-mode-visual-fill)
  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))


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

(global-set-key (kbd "M-q") 'compact-uncompact-block)

;; org roam
;; ln -s /data/data/com.termux/files/home/storage/shared/Documents/org-roam /data/data/org.gnu.emacs/files/Documents/org-roam
(use-package org-roam
  :after org
  :custom
  (org-roam-directory (file-truename "~/Documents/org-roam/"))
  :bind
  ((("C-c n l" . org-roam-buffer-toggle)
    ("C-c n r" . org-roam-node-random)
    ("C-c n i" . org-roam-node-insert)
    ("C-c n I" . yx-func/org-roam-node-insert-immediate)
    ("C-c n c" . org-roam-capture)
    ("C-c n f" . org-roam-node-find)))

  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory))

  (org-roam-db-autosync-enable)
  (org-roam-db-autosync-mode)

  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template
	(concat "${title:*} "
		(propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-capture-templates
	'(("d" "default" plain "%?"
           :if-new (file+head "${slug}.org"
                              "#+title: ${title}\n#+created: %u\n#+last_modified: \n#+filetags:\n\n")
           :unnarrowed t)))
  
  ;; bind to C-c n I
  (defun yx-func/org-roam-node-insert-immediate (arg &rest args)
    (interactive "P")
    (let ((args (push arg args))
          (org-roam-capture-templates (list (append (car org-roam-capture-templates)
                                                    '(:immediate-finish t)))))
      (apply #'org-roam-node-insert args))))

;; srs
(use-package org-srs
  :defer t
  :after fsrs org
  :hook (org-mode . org-srs-embed-overlay-mode)
  :bind (:map org-mode-map
         ("<f5>" . org-srs-review-rate-easy)
         ("<f6>" . org-srs-review-rate-good)
         ("<f7>" . org-srs-review-rate-hard)
         ("<f8>" . org-srs-review-rate-again)))

;; Latex
;; Export from org to latex
(setq org-latex-pdf-process
      '("latexmk -pdflatex='pdflatex -interaction nonstopmode' -pdf -bibtex -f %f"))
