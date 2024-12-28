import { writable } from 'svelte/store';

export const darkModeStore = writable(true);
export const sectionInfoStore = writable(null);
export const scrollStore = writable({isScroll: false, id: 0});
export const loading = writable(2);