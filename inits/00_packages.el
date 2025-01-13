;;; -*- lexical-binding: t -*-
;;

(setq package-list
      '(orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
	marginalia          ; Enrich existing commands with completion annotations
	deft                ; Quickly browse, filter, and edit plain text notes
	mini-frame          ; Show minibuffer in child frame on read-from-minibuffer
	visual-fill-column  ; Effect of visual-line-mode and fill-column
	cal-china-x         ; Holidays in china
	cnfonts             ; Adjust for chinese font
	org-roam            ; Org-roam
	))


(when is-android
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package)))
  
  ;; srs
  (unless (package-installed-p 'fsrs)
    (package-vc-install
     '(fsrs :url "https://github.com/bohonghuang/lisp-fsr")))
  
  (unless (package-installed-p 'org-srs)
    (package-vc-install
     '(org-srs :url "https://github.com/bohonghuang/org-srs"))))

(setq desktop-only-package-list
      (append package-list
	      '(ellama      ; language model tool
		magit       ; git client
		showkey     ; show what key do I use to type
		mailcap     ; Help handle mime data for emails
		auto-complete-auctex ; latex autocomplete
	        org-ref     ; bibliography management
		bibtex
		)))

(when (not is-android)

  (require 'straight)
  
  (straight-use-package '(org :type built-in))

  ;; speech to text
  (straight-use-package
   '(whisper :type git :host github :repo "natrys/whisper.el"))

  ;; text to speech 
  (straight-use-package
   '(piper :type git :host github :repo "boletopia/piper.el"))

  ;; srs
  (straight-use-package
  '(fsrs :type git :host github :repo "bohonghuang/lisp-fsrs"))

  (straight-use-package
   '(org-srs :type git :host github :repo "bohonghuang/org-srs"))

  (dolist (package desktop-only-package-list)
    (straight-use-package package)))
