<script lang="ts">
	import { base } from '$app/paths';
	import { onMount } from 'svelte';

	let section1: HTMLElement;
	let section2: HTMLElement;
	let visible1 = $state(false);
	let visible2 = $state(false);

	onMount(() => {
		const observe = (el: HTMLElement, setter: (v: boolean) => void) => {
			const observer = new IntersectionObserver(
				(entries) => {
					if (entries[0].isIntersecting) {
						setter(true);
						observer.disconnect();
					}
				},
				{ threshold: 0.15 }
			);
			observer.observe(el);
			return observer;
		};

		const o1 = observe(section1, (v) => (visible1 = v));
		const o2 = observe(section2, (v) => (visible2 = v));
		return () => {
			o1.disconnect();
			o2.disconnect();
		};
	});
</script>

<div class="py-16 md:py-24 px-6 space-y-24 md:space-y-32">
	<!-- Settings / Resolution filtering -->
	<div
		bind:this={section1}
		class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-10 md:gap-16 items-center transition-all duration-700 ease-out {visible1
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-8'}"
	>
		<img
			src="{base}/screenshot-app.png"
			alt="The Shy Dock settings window"
			class="rounded-xl"
		/>
		<div>
			<h2 class="font-serif text-3xl md:text-4xl tracking-tight mb-4">
				Works with any monitor. Or just the ones you pick.
			</h2>
			<p class="text-text-secondary dark:text-text-secondary-dark leading-relaxed">
				By default, any external display will trigger your dock. Want more control? Set a minimum resolution and it'll only react to the monitors that match.
			</p>
		</div>
	</div>

	<!-- Menu bar -->
	<div
		bind:this={section2}
		class="max-w-4xl mx-auto grid grid-cols-1 md:grid-cols-2 gap-10 md:gap-16 items-center transition-all duration-700 ease-out {visible2
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-8'}"
	>
		<div class="order-2 md:order-1">
			<h2 class="font-serif text-3xl md:text-4xl tracking-tight mb-4">
				Quietly lives in your menu bar.
			</h2>
			<p class="text-text-secondary dark:text-text-secondary-dark leading-relaxed">
				No dock icon, no windows in the way. Just a small menu bar item that shows your connection status and lets you toggle things when you need to.
			</p>
		</div>
		<img
			src="{base}/screenshot-menubar.png"
			alt="The Shy Dock menu bar dropdown"
			class="order-1 md:order-2 rounded-xl"
		/>
	</div>
</div>
