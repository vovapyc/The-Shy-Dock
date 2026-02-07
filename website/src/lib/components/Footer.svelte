<script>
	import { base } from '$app/paths';
</script>

<footer class="py-16 md:py-24 px-6 border-t border-border dark:border-night-border">
	<div class="max-w-md mx-auto text-center">
		<img
			src="{base}/app-icon.png"
			alt="The Shy Dock"
			class="w-14 h-14 mx-auto mb-6 opacity-80"
		/>

		<p class="font-serif text-xl md:text-2xl tracking-tight mb-3">
			Like it? Support the project.
		</p>
		<p class="text-sm text-text-secondary dark:text-text-secondary-dark mb-8">
			Star on GitHub, share with a friend, or just say hi.
		</p>

		<div class="flex items-center justify-center gap-6">
			<a
				href="https://github.com/vovapyc/The-Shy-Dock"
				target="_blank"
				rel="noopener noreferrer"
				class="text-sm text-text-secondary dark:text-text-secondary-dark hover:text-text-primary dark:hover:text-text-primary-dark transition-colors underline decoration-dotted underline-offset-4"
			>
				github.com
			</a>
			<a
				href="https://byvova.com"
				target="_blank"
				rel="noopener noreferrer"
				class="text-sm text-text-secondary dark:text-text-secondary-dark hover:text-text-primary dark:hover:text-text-primary-dark transition-colors underline decoration-dotted underline-offset-4"
			>
				byvova.com
			</a>
		</div>
	</div>
</footer>
