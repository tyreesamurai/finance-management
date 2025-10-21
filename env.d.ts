//// <reference types="vite/client" />

declare module "*.vue" {
	import type { DefineComponent } from "vue";
	const component: DefineComponent<
		Record<string, unknown>,
		Record<string, unknown>,
		// biome-ignore lint/suspicious/noExplicitAny: Just let this one be any please
		any
	>;
	export default component;
} // <reference types="vite/client" />
