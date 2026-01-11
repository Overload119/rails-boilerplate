import React from 'react'
import { usePage } from '@inertiajs/react'
import type { SharedProps } from '../types'

interface AppLayoutProps {
  children: React.ReactNode
  title?: string
}

export default function AppLayout({ children, title }: AppLayoutProps) {
  const { props } = usePage<SharedProps>()
  const { flash, app } = props

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-950 via-slate-900 to-slate-800">
      {/* Flash Messages */}
      <div className="fixed top-4 right-4 z-50 space-y-2">
        {flash?.success && (
          <div className="animate-in slide-in-from-right rounded-lg bg-emerald-500/90 px-4 py-3 text-white shadow-lg backdrop-blur-sm">
            {flash.success}
          </div>
        )}
        {flash?.error && (
          <div className="animate-in slide-in-from-right rounded-lg bg-red-500/90 px-4 py-3 text-white shadow-lg backdrop-blur-sm">
            {flash.error}
          </div>
        )}
      </div>

      <div className="container mx-auto px-4 py-16">
        <div className="mx-auto max-w-2xl">
          {/* Header */}
          <div className="mb-10 text-center">
            <h1 className="bg-gradient-to-r from-rose-500 to-pink-500 bg-clip-text text-6xl font-black tracking-tight text-transparent drop-shadow-2xl">
              {title || 'todos'}
            </h1>
            <p className="mt-2 text-sm text-slate-500">
              Powered by {app?.name || 'Rails'} + Inertia.js + React + shadcn/ui
            </p>
          </div>

          {children}
        </div>
      </div>
    </div>
  )
}
