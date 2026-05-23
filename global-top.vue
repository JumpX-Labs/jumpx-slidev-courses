<template>
  <header 
    v-if="$nav.currentPage !== 1"
    class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between p-4 pointer-events-none select-none"
  >
    <a 
      href="/courses" 
      class="pointer-events-auto text-[#B85A2A] hover:text-[#9A4E23] transition-colors duration-200 flex items-center gap-1.5 font-semibold text-sm bg-white/90 border border-gray-200/80 px-4 py-2 rounded-full backdrop-blur-md shadow-sm"
    >
      <span>← 返回课程目录</span>
    </a>
    <div 
      class="pointer-events-auto flex items-center gap-3 text-xs font-semibold text-gray-600 bg-white/90 border border-gray-200/80 px-4 py-2 rounded-full backdrop-blur-md shadow-sm"
    >
      <span class="max-w-[240px] truncate text-gray-500 font-medium">{{ $slidev.configs.title }}</span>
      <span class="text-gray-300 font-normal">|</span>
      <span class="text-[#B85A2A] font-bold min-w-[40px] text-right">{{ $nav.currentPage }} / {{ $nav.total }}</span>
    </div>
  </header>
</template>

