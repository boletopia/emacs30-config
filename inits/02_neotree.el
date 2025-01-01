;;; 02_neotree.el --- Org mode configurations. -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(use-package neotree :ensure t
  ;; Sidebar for dired. This config is copied from https://gist.github.com/Ladicle/119c57fc97439c1b103f7847aa03be52"
  ;; "https://github.com/jaypei/emacs-neotree"
  :straight '(neotree
              :type git
              :host github
              :repo "jaypei/emacs-neotree")
  :config
  (defun neo-hide-nano-header ()
    "Hide nano header."
    (interactive)
    (setq header-line-format ""))
  
  (defun neotree-projectile-toggle ()
    "Toggle function for projectile."
    (interactive)
    (let ((project-dir
           (ignore-errors
             (projectile-project-root)))
          (file-name (buffer-file-name)))
      (if (and (fboundp 'neo-global--window-exists-p)
               (neo-global--window-exists-p))
          (neotree-hide)
        (progn
          (neotree-show)
          (if project-dir
              (neotree-dir project-dir))
          (if file-name
              (neotree-find file-name))))))

  ;; Use nerd font in terminal.
  (unless (window-system)
    (advice-add
     'neo-buffer--insert-fold-symbol
     :override
     (lambda (name &optional node-name)
       (let ((n-insert-symbol (lambda (n)
                                (neo-buffer--insert-with-face
                                 n 'neo-expand-btn-face))))
         (or (and (equal name 'open) (funcall n-insert-symbol " "))
             (and (equal name 'close) (funcall n-insert-symbol " "))
             (and (equal name 'leaf) (funcall n-insert-symbol "")))))))

  :bind (([f8] . neotree-projectile-toggle))

  :hook ((neotree-mode-hook . neo-hide-nano-header))

  :custom
  (neo-theme  'nerd)
  (neo-cwd-line-style  'button)
  (neo-autorefresh  t)
  (neo-show-hidden-files  t)
  (neo-mode-line-type  nil)
  (neo-window-fixed-size  nil))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:
;;; 02_neotree.el ends here
