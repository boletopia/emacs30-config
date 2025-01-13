;;; -*- lexical-binding: t -*-
;; ellama
;; https://github.com/s-kostyaev/ellama
;; provide methods interacting with llms

(require 'ellama)
(require 'llm-ollama)
(setopt ellama-provider
        (make-llm-ollama
         ;; this model should be pulled to use it
         ;; value should be the same as you print in terminal during pull
         :chat-model "llama3.2"
         :embedding-model "nomic-embed-text"))



;; whisper
;; https://github.com/natrys/whisper.el
(use-package whisper
  :bind (([f8] . 'whisper-run)
         ("C-c w" . 'whisper-run))
  :config
  ;; under this path we should find the whisper.cpp repo
  (cond (is-work-pc (setq whisper-install-directory (concat "/home/ANT.AMAZON.COM/" user-real-login-name "/")))
        (is-work-pc-cloud (setq whisper-install-directory (concat "/home/" user-real-login-name "/")))
        (t (setq whisper-install-directory (concat "/home/" user-real-login-name "/Src/"))))
  
  (setq whisper-model "medium"
        whisper-language "en"
        whisper-translate nil
        whisper-recording-timeout 300
        whisper-enable-speed-up "2x")
  
  ;; Needed some help to do this. Opened an issue
  ;; https://github.com/natrys/whisper.el/issues/19
  ;; For the first problem, you can just copy whisper--temp-file to
  ;; wherever you want once the transcription is done. So the problem
  ;; boils down to the question of how to run some custom elisp logic,
  ;; once some other elisp function runs. Typically library authors
  ;; provide "hooks" where you can register your function implementing
  ;; custom logic, which then gets run at predefined points. Here we
  ;; provide whisper-pre-process-hook and whisper-post-process-hook
  ;; which could be used to register various bits of custom logic (see
  ;; the readme).
  ;; (As an aside, if library authors don't provide such
  ;; hooks, then you can generally use Emacs' advice system (e.g.
  ;; :after advice would run an advice function after some function
  ;; runs).
  ;; Unfortunately this doesn't quite work here because whisper-run is
  ;; async and immediately returns, so advice function would
  ;; immediately run too, even before transcription is done) While you
  ;; can do the saving in the whisper-post-process-hook, the second
  ;; problem is slightly trickier. Every function in that hook is run
  ;; with current buffer set to the temporary buffer that contains
  ;; only the transcribed output (because this hook is meant for
  ;; post-processing text only). However you can recover the original
  ;; point location from the internal variable whisper--marker which
  ;; is a marker object.
  ;; Some code is probably easier understood than words. I think you
  ;; want something like this in your config:
  (defvar my-save-whisper-audio t)

  (defun my-save-whisper-audio-clip ()
    (when my-save-whisper-audio
      (let* ((archive-name (format-time-string (concat "%Y%m%d-%H%M%S-" machine-id ".wav")))
             (archive-file (file-name-concat org-directory "recording" archive-name)))

        (make-directory (file-name-directory archive-file) t)
        (copy-file whisper--temp-file archive-file)

        (with-current-buffer (marker-buffer whisper--marker)
          (goto-char whisper--marker)
          (when (eq major-mode 'org-mode)
            (org-set-property "AUDIO_SOURCE" archive-file))))))

  (add-hook 'whisper-post-process-hook 'my-save-whisper-audio-clip 100))


;; piper
;; https://github.com/akhil3417/Doom-Emacs-Config/blob/fb0a78adcce887b3b9fd36cb8b8c8072f9cafd4c/lisp/helper-funcs.el#L292
