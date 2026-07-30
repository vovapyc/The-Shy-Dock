import posthog from 'posthog-js';
import { browser } from '$app/environment';

export const prerender = true;

export const load = async () => {
  if (browser) {
    posthog.init(
      'phc_vmyGKk9d2D9GzpJZH6p5YWW67cP4Qnndt2miMWejurwi',
      {
        api_host: 'https://pineapple.byvova.com',
        capture_pageview: false,
        capture_pageleave: false,
        capture_exceptions: true, // This enables capturing exceptions using Error Tracking
      }
    );
    posthog.register({ project: 'the-shy-dock' });
  }
  return;
};
