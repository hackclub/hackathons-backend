import Appsignal from "@appsignal/javascript";
import {plugin as breadcrumbsConsole} from "@appsignal/plugin-breadcrumbs-console";
import {plugin as breadcrumbsNetwork} from "@appsignal/plugin-breadcrumbs-network";
import {plugin as pathDecorator} from "@appsignal/plugin-path-decorator"

export const appsignal = new Appsignal({
  key: Hackathons.appsignal.key,
});

appsignal.use(breadcrumbsConsole());
appsignal.use(breadcrumbsNetwork());
appsignal.use(pathDecorator());
