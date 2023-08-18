import Appsignal from "@appsignal/javascript";
import {plugin as breadcrumbsConsole} from "@appsignal/plugin-breadcrumbs-console";
import {plugin as breadcrumbsNetwork} from "@appsignal/plugin-breadcrumbs-network";
import {plugin as pathDecorator} from "@appsignal/plugin-path-decorator"

export const appsignal = new Appsignal({
    // Frontend API key (intended to be exposed publicly)
    key: "5b516ead-40f6-4ed3-8012-40c3882bfc90",
});

appsignal.use(breadcrumbsConsole());
appsignal.use(breadcrumbsNetwork());
appsignal.use(pathDecorator());

console.log("Appsignal:", appsignal);
