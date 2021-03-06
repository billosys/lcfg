;;;; This provides support for setting up logging systems from the
;;;; lfe.config file. Note, however, that you will need to ensure that
;;;; your preferred logging system is available (e.g., as a dependency
;;;; in your rebar.config or lfe.config file).
;;;;
(defmodule lcfg-log
  (export all))

(include-lib "lutil/include/core.lfe")

(defun setup ()
  (setup (get-logging-config)))

(defun setup (config)
  (case (get-in config 'backend)
    ('lager (setup-lager config))))

(defun get-logging-config ()
  (let ((local (get-local-logging)))
    (if (and (=/= local '()) (=/= local 'undefined))
        local
        (get-globgal-logging))))

(defun get-local-logging ()
  (get-logging (lcfg-file:parse-local)))

(defun get-globgal-logging ()
  (get-logging (lcfg-file:parse-global)))

(defun get-logging
  (('())
    '())
  ((config)
    (get-in config 'logging)))

(defun setup-lager (config)
  (application:load 'lager)
  (application:set_env
    'lager
    'handlers
    (get-in config 'options))
  (lager:start))
