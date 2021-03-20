;;; keybindings.el -*- lexical-binding: t; -*-

;; ---------------------------------------
;; Emacs
;; ---------------------------------------
(map! :map global-map
      :leader
      :desc "Toggle frame maximized"
      :nv "tm" #'toggle-frame-maximized)

;; ---------------------------------------
;; Clojure
;; ---------------------------------------
(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Eval defun at point"
      :nv "ef" #'cider-eval-defun-at-point)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Eval defun at point"
      :nv "ef" #'cider-eval-defun-at-point)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Format defn"
      :nv "ff" #'cider-format-defun)

(map! :after clojure-mode
      :map clojure-mode-map
      :localleader
      :desc "Format buffer"
      :nv "fb" #'cider-format-buffer)

;; ---------------------------------------
;; Forms
;; ---------------------------------------
(map! :after with-editor
      :map with-editor-mode-map
      :localleader
      :nv "," #'with-editor-finish)

(map! :after with-editor
      :map with-editor-mode-map
      :localleader
      :nv "a" #'with-editor-cancel)

;; ---------------------------------------
;; Dired
;; ---------------------------------------
(map! :after dired
      :map dired-mode-map
      :leader
      :desc "Dired jump"
      :nv "fj" #'dired-jump)
