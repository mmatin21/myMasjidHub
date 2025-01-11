// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
import TableController from "./table_controller"
import ModalController from "./modal_controller"
eagerLoadControllersFrom("controllers", application)
application.register("table", TableController)
application.register("modal", ModalController)
