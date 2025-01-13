;; -*- lexical-binding: t -*-

;; This is needed as of Org 9.2
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("py" . "src python :results result"))
(add-to-list 'org-structure-template-alist '("pyg" . "src python :results file :var f= :return f
plt.savefig(f)
plt.clf()"))
(add-to-list 'org-structure-template-alist '("jl" . "src julia :results result"))
(add-to-list 'org-structure-template-alist '("r" . "src R :results output"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("toml" . "src toml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))
(add-to-list 'org-structure-template-alist '("scala" . "src scala"))
(add-to-list 'org-structure-template-alist '("sql" . "src sql"))

;; org-babel defaults
(setq-default org-src-fontify-natively t         ; Fontify code in code blocks.
              org-adapt-indentation nil          ; Adaptive indentation
              org-src-tab-acts-natively t        ; Tab acts as in source editing
              org-confirm-babel-evaluate nil     ; No confirmation before executing code
              org-edit-src-content-indentation 0 ; No relative indentation for code blocks
              org-fontify-whole-block-delimiter-line t) ; Fontify whole block

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (julia . t)
   (python . t)
   (R . t)
   (sql . t)
   (shell . t)))

(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)
