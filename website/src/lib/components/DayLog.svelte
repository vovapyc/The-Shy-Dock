<script lang="ts">
	import { onMount } from 'svelte';

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

<section bind:this={sectionEl} class="py-16 md:py-24 px-6">
	<div
		class="max-w-2xl mx-auto transition-all duration-700 ease-out {visible
			? 'opacity-100 translate-y-0'
			: 'opacity-0 translate-y-6'}"
	>
		<p class="text-center font-serif text-2xl md:text-3xl leading-relaxed tracking-tight mb-10">
			It just works in the background. All day. 👀
		</p>

		<div class="bg-night dark:bg-night-card rounded-2xl p-6 md:p-8 font-mono text-sm border border-night-border shadow-sm overflow-x-auto">
			<table class="w-full">
				<tbody class="leading-relaxed">
					<tr class="text-text-tertiary-dark">
						<td class="pr-4 whitespace-nowrap py-1 text-text-secondary-dark tabular-nums">09:00</td>
						<td class="pr-4 py-1">laptop only</td>
						<td class="py-1 text-right text-gold">dock hidden</td>
					</tr>
					<tr class="text-text-tertiary-dark">
						<td class="pr-4 whitespace-nowrap py-1 text-text-secondary-dark tabular-nums">10:30</td>
						<td class="pr-4 py-1">plugged into Dell U2723QE</td>
						<td class="py-1 text-right text-green-400">dock visible</td>
					</tr>
					<tr class="text-text-tertiary-dark">
						<td class="pr-4 whitespace-nowrap py-1 text-text-secondary-dark tabular-nums">12:15</td>
						<td class="pr-4 py-1">lunch, laptop unplugged</td>
						<td class="py-1 text-right text-gold">dock hidden</td>
					</tr>
					<tr class="text-text-tertiary-dark">
						<td class="pr-4 whitespace-nowrap py-1 text-text-secondary-dark tabular-nums">13:00</td>
						<td class="pr-4 py-1">back at desk, Studio Display</td>
						<td class="py-1 text-right text-green-400">dock visible</td>
					</tr>
					<tr class="text-text-tertiary-dark">
						<td class="pr-4 whitespace-nowrap py-1 text-text-secondary-dark tabular-nums">18:00</td>
						<td class="pr-4 py-1">heading home</td>
						<td class="py-1 text-right text-gold">dock hidden</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>
</section>
