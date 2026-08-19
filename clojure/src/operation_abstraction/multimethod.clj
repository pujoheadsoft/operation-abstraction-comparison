(ns operation-abstraction.multimethod)

(defmulti lookup-name :source)

(defmethod lookup-name :memory [{:keys [user-id]}]
  (if (= user-id 1) "Ada" "Unknown"))

(defmethod lookup-name :remote [{:keys [user-id]}]
  (str "remote-user-" user-id))

(defmulti record-greeting :channel)

(defmethod record-greeting :console [{:keys [name]}]
  (println (str "log: greeted " name)))

(defmethod record-greeting :audit [{:keys [name]}]
  (println (str "audit: greeted " name)))

(defn greet [user]
  (let [name (lookup-name user)]
    (record-greeting {:channel (:channel user) :name name})
    (str "Hello, " name "!")))

(defn -main []
  (println (greet {:source :memory :channel :console :user-id 1})))

