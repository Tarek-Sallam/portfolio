import { writable } from 'svelte/store';

export const cameraStore = writable(0);
export const scrollStore = writable(true);
export const sectionStore = writable(0);