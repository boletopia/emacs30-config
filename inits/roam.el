;;  ln -s /data/data/com.termux/files/home/storage/shared/Documents/org-roam /data/data/org.gnu.emacs/files/Documents/org-roam

(use-package org-roam 
  :after org
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

  (org-roam-setup)
  
  (org-roam-db-autosync-mode)

  (setq org-roam-node-display-template
	(concat "${title:*} "
		(propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-directory "~/Documents/org-roam")

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

