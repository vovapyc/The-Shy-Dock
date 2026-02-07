<script lang="ts">
	import { onMount } from 'svelte';

	const steps = [
		{
			number: '01',
			title: 'Install',
			description: 'Download the app, drag to Applications, and grant accessibility permission.'
		},
		{
			number: '02',
			title: 'Connect',
			description: 'Plug in an external display. Your dock automatically appears.'
		},
		{
			number: '03',
			title: 'Disconnect',
			description: 'Unplug the display. Your dock hides itself, giving you a clean desktop.'
		}
	];

	let sectionEl: HTMLElement;
	let visible = $state(false);

	onMount(() => {
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries[0].isIntersecting) {
					visible = true;
					observer.disconnect();
				}
			},
			{ threshold: 0.1 }
		);
		observer.observe(sectionEl);
		return () => observer.disconnect();
	});
</script>

<section bind:this={sectionEl} class="py-20 md:py-32 px-6 bg-cream-dark dark:bg-night-card">
	<div class="max-w-4xl mx-auto">
		<div
			class="text-center mb-16 transition-all duration-700 ease-out {visible
				? 'opacity-100 translate-y-0'
				: 'opacity-0 translate-y-6'}"
		>
			<h2 class="font-serif text-4xl md:text-5xl tracking-tight mb-4">How it works</h2>
			<p class="text-text-secondary dark:text-text-secondary-dark text-lg">
				Three steps. Zero configuration after that.
			</p>
		</div>

		<div class="grid grid-cols-1 md:grid-cols-3 gap-8 md:gap-12">
			{#each steps as step, i}
				<div
					class="text-center transition-all duration-700 ease-out"
					style="transition-delay: {visible ? i * 150 : 0}ms"
					class:opacity-0={!visible}
					class:translate-y-6={!visible}
					class:opacity-100={visible}
					class:translate-y-0={visible}
				>
					<span class="inline-block text-gold font-serif text-5xl mb-4">{step.number}</span>
					<h3 class="font-medium text-lg mb-2">{step.title}</h3>
					<p class="text-sm text-text-secondary dark:text-text-secondary-dark leading-relaxed">
						{step.description}
					</p>
				</div>
			{/each}
		</div>
	</div>
</section>
