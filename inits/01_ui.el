;;; 01_ui.el --- Org mode configurations. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package visual-fill-column :ensure t
  ;; "https://codeberg.org/joostkremers/visual-fill-column"
  ;; mimics the effect of fill-column in visual-line-mode. I use it to achieve fill-column in org mode
  :config
  (defun yx-func/org-mode-visual-fill ()
    (setq visual-fill-column-width 110
          visual-fill-column-center-text t)
    (visual-fill-column-mode 1))
  (add-hook 'org-mode-hook #'yx-func/org-mode-visual-fill)
  (advice-add 'text-scale-adjust :after #'visual-fill-column-adjust))


(use-package adaptive-wrap :ensure t
  ;; "https://elpa.gnu.org/packages/adaptive-wrap.html"
  ;; ensures that if the first line of a paragraph is indented or has, e.g., a mail quote prefix (> ), this is applied to the entire paragraph
  :config
  (add-hook 'org-mode-hook #'adaptive-wrap-prefix-mode))


(use-package doom-themes :ensure t
  :hook (emacs-startup-hook . (lambda () (load-theme 'doom-solarized-light t)))
  :custom ((doom-themes-enable-italic . nil))
  :config
  (doom-themes-neotree-config)
  (doom-themes-org-config))

(use-package all-the-icons :ensure t)
  ;; All the icons is used by NeoTree
  ;; "https://github.com/domtronn/all-the-icons.el")

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 01_ui.el ends here
