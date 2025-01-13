;;; -*- lexical-binding: t -*-
;;

(setq package-list
      '(orderless           ; Completion style for matching regexps in any order
        vertico             ; VERTical Interactive COmpletion
	marginalia          ; Enrich existing commands with completion annotations
	mini-frame          ; Show minibuffer in child frame on read-from-minibuffer
	cal-china-x         ; Holidays in china
	cnfonts             ; Adjust for chinese font
	org-roam            ; Org-roam
	))


(when is-android
  (dolist (package package-list)
    (unless (package-installed-p package)
      (package-install package))))


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

  (dolist (package desktop-only-package-list)
    (straight-use-package package)))
