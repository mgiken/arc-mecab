(require "ffi.arc")

(w/ffi "libmecab"
  (cdef mecab-model-new            "mecab_model_new2"           cptr    (cstring))
  (cdef mecab-model-new-tagger     "mecab_model_new_tagger"     cptr    (cptr))
  (cdef mecab-model-new-lattice    "mecab_model_new_lattice"    cptr    (cptr))
  (cdef mecab-lattice-set-sentence "mecab_lattice_set_sentence" cvoid   (cptr cstring))
  (cdef mecab-parse-lattice        "mecab_parse_lattice"        cint    (cptr cptr))
  (cdef mecab-lattice-tostr        "mecab_lattice_tostr"        cstring (cptr))
  (cdef mecab-destroy              "mecab_destroy"              cvoid   (cptr))
  (cdef mecab-lattice-destroy      "mecab_lattice_destroy"      cvoid   (cptr))
  (cdef mecab-model-destroy        "mecab_model_destroy"        cvoid   (cptr))
  )

(= mecab-arg* "")

(def mecab (s (o test) (o arg mecab-arg*))
  (withs (mdl nil mec nil lat nil)
    (after (do (= mdl (mecab-model-new arg)
                  mec (mecab-model-new-tagger mdl)
                  lat (mecab-model-new-lattice mdl))
               (mecab-lattice-set-sentence lat s)
               (mecab-parse-lattice mec lat)
               (accum a
                 (w/instring ins (mecab-lattice-tostr lat)
                   (whiler line (readline ins) "EOS"
                     (let node (tokens line #\tab)
                       (if test
                           (only.a:test node)
                           (a node)))))))
           (and mec (mecab-destroy mec))
           (and lat (mecab-lattice-destroy lat))
           (and mdl (mecab-model-destroy mdl)))))
