;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auto-complete csv-mode dap-mode esxml fold-this go-mode highlight
     highlight-indentation indent-bars indent-guide protobuf-mode pytest
     rainbow-mode react-snippets spell-fu web-beautify zig-mode))
 '(warning-suppress-log-types '((lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setenv "LSP_USE_PLISTS" "true")

;; Go lsp
(add-to-list 'exec-path (expand-file-name "~/go/bin"))

;;(require 'dape)
;;(add-to-list 'dape-configs
;;             `(debugpy
;;               modes (python-ts-mode python-mode)
;;               command "python"
;;               command-args ("-m" "debugpy.adapter")
;;               :type "executable"
;;               :request "launch"
;;	       :console "integratedTerminal"
;;	       :showReturnValue nil ;;t
;;	       :justMyCode nil
;;               :cwd dape-cwd-fn
;;               ;;:program dape-find-file-buffer-default
;;               ))
;;
;;
;;(setq dape-config-pytest '((mode . "python")
;;                           (command . "python")
;;                           (args . ("-m" "debugpy.adapter" "--wait-for-client" "--" "pytest" "-s" "-v"))))

; size
;30 - 34
;15 - 18

(setq doom-font (font-spec :family "Hack" :size 30 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Hack" :size 34))


(setq markdown-split-window-direction 'right)
(setq-default delete-by-moving-to-trash t)
(global-visual-line-mode t)
(setq-default delete-selection-mode 1)


(add-hook! 'rainbow-mode-hook
  (hl-line-mode (if rainbow-mode -1 +1)))


(add-hook 'python-mode-hook 'lsp)
(add-hook 'csharp-mode-hook 'lsp)

(add-hook 'go-mode-hook 'lsp)

; CPP setup
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(after! company
  (setq company-frontends '(company-pseudo-tooltip-frontend)
        company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-show-quick-access t)
  )

(after! dap-mode
  (setq dap-python-debugger 'debugpy))

(use-package! dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-python)
  (setq dap-python-debugger 'debugpy))

;(use-package company-quickhelp
;  :ensure t
;  :config
;  (company-quickhelp-mode 1)
;  (setq company-quickhelp-delay 0.5)) ; Delay before help popup appears


;(use-package! copilot
;  :hook (prog-mode . copilot-mode)
;  :bind (:map copilot-completion-map
;              ("<tab>" . 'copilot-accept-completion)
;              ("TAB" . 'copilot-accept-completion)
;              ("C-TAB" . 'copilot-accept-completion-by-word)
;              ("C-<tab>" . 'copilot-accept-completion-by-word)))


;;(with-eval-after-load 'copilot
;;  (defun copilot--infer-indentation-offset ()
;;    (or (copilot--get-indentation-offset-from-mode)
;;        (copilot--get-indentation-offset-from-buffer)
;;        4))) ; Default to 4 spaces if no offset is found


; Protobuf lsp
(after! lsp-mode
  (add-to-list 'lsp-language-id-configuration '(protobuf-mode . "protobuf"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("buf" "lsp" "serve"))
                    :activation-fn (lsp-activate-on "protobuf")
                    :server-id 'buf)))

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))
(add-hook 'protobuf-mode-hook #'lsp-deferred)

(after! markdown-mode
  (setq markdown-max-image-size '(800 . 600))
  (add-hook 'markdown-mode-hook #'markdown-display-inline-images))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-view-mode))


(defun my/proxy-toggle ()
  (interactive)
  (if (getenv "http_proxy")
      (progn
        (dolist (v '("http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"))
          (setenv v nil))
        (setq url-proxy-services nil)
        (message "Proxy OFF"))
    (let ((p "http://127.0.0.1:2080"))
      (dolist (v '("http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"))
        (setenv v p))
      (setq url-proxy-services
            '(("http"     . "127.0.0.1:2080")
              ("https"    . "127.0.0.1:2080")
              ("no_proxy" . "^\\(localhost\\|127\\.0\\.0\\.1\\)")))
      (message "Proxy ON"))))

(package-initialize)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


