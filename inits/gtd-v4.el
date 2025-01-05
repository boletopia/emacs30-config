;;; Source https://www.labri.fr/perso/nrougier/GTD/index.html

;; Key bindings

;; | Command                          | Bindings         | Mode + where           |
;; |----------------------------------+------------------|------------------------|
;; | Agenda                           | *C-c a*            | any                    |
;; | Agenda for today                 | *C-c a a*          | any                    |
;; |                                  |                  |                        |
;; | Capture menu                     | *C-c c*            | any                    |
;; | Capture meeting (agenda.org)     | *C-c c m*          | any                    |
;; | Capture meeting note (notes.org) | *C-c c n*          | any                    |
;; | Capture generic TODO (inbox.org) | *C-c i* or *C-c c i* | any                    |
;; | Capture mail TODO (inbox.org)    | *C-c i* or *C-c c @* | mu4e view/headers mode |
;; |                                  |                  |                        |
;; | Add/Remove tag                   | *C-c C-c*          | org-mode on headline   |
;; | Update progress indicator        | *C-c C-c*          | org-mode on [/]        |
;; | Update all progress indicators   | *C-u C-c #*        | org-mode               |
;; | Enter estimated effort           | *C-c C-x e*        | org-mode on headline   |
;; | Refile section                   | *C-c C-w*          | org-mode on headline   |
;; | Move to next TODO state          | *S-right*          | org-mode on TODO       |
;; |                                  |                  |                        |
;; | Clock in                         | *C-c C-x C-i*      | org-mode on headline   |
;; | Clock out                        | *C-c C-x C-o*      | org-mode on headline   |
;; |                                  |                  |                        |
;; | Plain timestamp                  | *C-c .*            | org-mode               |
;; | Scheduled timestamp              | *C-c s*            | org-mode               |
;; | Deadline timestamp               | *C-c d*            | org-mode               |
;; | Inactive timestamp               | *C-c !*            | org-mode               |

(require 'org)

;; Files
(setq org-directory "~/Documents/org")
(setq org-agenda-files 
      (mapcar 'file-truename 
	      (file-expand-wildcards "~/Documents/org/*.org")))
;; Capture
(setq org-capture-templates
      `(("i" "Inbox" entry  (file "inbox.org")
        ,(concat "* TODO %?\n"
                 "/Entered on/ %U"))
        ("m" "Meeting" entry  (file+headline "agenda.org" "Future")
        ,(concat "* %? :meeting:\n"
                 "<%<%Y-%m-%d %a %H:00>>"))
        ("n" "Note" entry  (file "notes.org")
        ,(concat "* Note (%a)\n"
                 "/Entered on/ %U\n" "\n" "%?"))
        ("@" "Inbox [mu4e]" entry (file "inbox.org")
        ,(concat "* TODO Reply to \"%a\" %?\n"
                 "/Entered on/ %U"))))

(defun org-capture-inbox ()
     (interactive)
     (call-interactively 'org-store-link)
     (org-capture nil "i"))

(defun org-capture-mail ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "@"))

;; Use full window for org-capture
(add-hook 'org-capture-mode-hook 'delete-other-windows)

;; Key bindings
(define-key global-map            (kbd "C-c a") 'org-agenda)
(define-key global-map            (kbd "C-c c") 'org-capture)
(define-key global-map            (kbd "C-c i") 'org-capture-inbox)

;; Only if you use mu4e
;; (require ';; mu4e)
;; (define-key mu4e-headers-mode-map (kbd "C-c i") 'org-capture-mail)
;; (define-key
;;  mu4e-view-mode-map    (kbd "C-c i") 'org-capture-mail)

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets
      '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

;; TODO
(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "HOLD(h)" "|" "DONE(d)")))
(defun log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))
(add-hook 'org-after-todo-state-change-hook #'log-todo-next-creation-date)

;; Agenda
(setq org-agenda-custom-commands
      '(("g" "Get Things Done (GTD)"
         ((agenda ""
                  ((org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'deadline))
                   (org-deadline-warning-days 0)))
          (todo "NEXT"
                ((org-agenda-skip-function
                  '(org-agenda-skip-entry-if 'deadline))
                 (org-agenda-prefix-format "  %i %-12:c [%e] ")
                 (org-agenda-overriding-header "\nTasks\n")))
          (agenda nil
                  ((org-agenda-entry-types '(:deadline))
                   (org-agenda-format-date "")
                   (org-deadline-warning-days 7)
                   (org-agenda-skip-function
                    '(org-agenda-skip-entry-if 'notregexp "\\* NEXT"))
                   (org-agenda-overriding-header "\nDeadlines")))
          (tags-todo "inbox"
                     ((org-agenda-prefix-format "  %?-12t% s")
                      (org-agenda-overriding-header "\nInbox\n")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today\n")))))))

;; Save the corresponding buffers
(defun gtd-save-org-buffers ()
  "Save `org-agenda-files' buffers without user confirmation.
See also `org-save-all-org-buffers'"
  (interactive)
  (message "Saving org-agenda-files buffers...")
  (save-some-buffers t (lambda () 
			 (when (member (buffer-file-name) org-agenda-files) 
			   t)))
  (message "Saving org-agenda-files buffers... done"))

;; Add it after refile
(advice-add 'org-refile :after
	    (lambda (&rest _)
	      (gtd-save-org-buffers)))
