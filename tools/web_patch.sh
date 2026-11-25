#!/bin/sh
# N64Recomp-browser's web support (README.md, "The web page") on top of this game's own patches in recomp/, which
# must be in already: ./tools/web_patch.sh, from the clone's folder. build.sh runs it. Every change is behind
# __EMSCRIPTEN__ or __wasm__, so the game builds as before natively. Applied a project at a time, each left alone
# if it is patched already, with files left out where recomp/'s patches change the same lines:
# - N64Recomp's src/analysis.cpp in tools/N64Recomp, the recompiler build.sh builds, whose change finds a jump table
#   in another section: recomp/n64recomp.patch does that its own way (the runtime's N64Recomp, whose recomp.h the
#   game's code includes, takes the whole patch).
# - rt64's src/hle/rt64_game_frame.h, whose one change (buildCallHashMap takes a sorted vector, as the web's
#   rt64_game_frame.cpp defines it) sits beside lines recomp/rt64.patch changes: tools/web_rt64_game_frame.patch
#   makes it on top of those.
# - the runtime's ultramodern/src/timer.cpp, which recomp/n64modernruntime.patch rewrites (its timers in a list under a
#   lock): tools/web_timer.patch makes the web's change there, a timer less than 2 ms away polled for, since the page's
#   timed waits can end late (Firefox on Windows ends them on the system timer's 15.6 ms tick).
# - rt64's src/hle/rt64_workload_queue.cpp, where the web's line that keeps a hidden page to its game's own frames (no
#   interpolated ones: nothing is presented, and Firefox queued them all) follows the one recomp/rt64.patch changes
#   (Conker's own pause of interpolation): tools/web_rt64_workload_queue.patch makes the web's whole change to the file
#   on top of Conker's, as N64Recomp-browser's commit WORKLOAD_QUEUE_MERGED_FROM has it, and the merge of what the web
#   has changed in it since starts there. A web from before that commit has no such line, and patches the file with
#   the rest.
# - seven more of rt64's, RT64_FILES, where recomp/rt64.patch's later changes (the pause menu's blur and It's War's
#   grey picture drawn by RT64, a present repeated while the game draws none, tile copies found again at any
#   resolution) meet the web's: tools/web_rt64.patch makes the web's whole change to them on top of Conker's, as
#   N64Recomp-browser's commit RT64_MERGED_FROM has it, and the merge of what the web has changed in them since starts
#   there. In it a repeated present shows its frame once with no interpolated ones, as Conker's does, and the blur's
#   new compute shader is built and included as WGSL too.
# - three of the runtime's, RUNTIME_FILES, where recomp/n64modernruntime.patch's later changes (a guard on each side of
#   the game's memory, a present repeated while the timeline has stopped) meet the web's (only the memory size committed
#   on Windows, the renderer readied for the game): tools/web_n64modernruntime.patch makes the web's whole change to
#   them on top of Conker's, as N64Recomp-browser's commit RUNTIME_MERGED_FROM has it, and the merge of what the web has
#   changed in them since starts there.
# - four of RecompFrontend's, FRONTEND_FILES, where recomp/recompfrontend.patch's later changes (the mouse wheel bound as
#   an input, a present repeated, each port's own profile in single-player mode) meet the web's (pads in order, the
#   renderer readied for the game, Assign players in single-player mode): tools/web_recompfrontend.patch makes the web's
#   whole change to them on top of Conker's but that last, since this game's single-player header has its players
#   already, as N64Recomp-browser's commit FRONTEND_MERGED_FROM has it, and the merge of what the web has changed in them
#   since starts there.
# The first three make the web's change as N64Recomp-browser's commit MERGED_FROM has it; what the web has changed in
# them since is merged in (apply.cmake --since), so a later web change reaches the page by itself. One that meets
# recomp/'s lines stops, the file left with conflict markers: merge it into tools/web_*.patch (analysis.cpp: into
# recomp/n64recomp.patch) by hand and move MERGED_FROM (rt64_workload_queue.cpp's: WORKLOAD_QUEUE_MERGED_FROM;
# RT64_FILES': RT64_MERGED_FROM; RUNTIME_FILES': RUNTIME_MERGED_FROM; FRONTEND_FILES': FRONTEND_MERGED_FROM) to the commit
# merged from.
# timer.cpp's merge starts later, at TIMER_MERGED_FROM: there the web keeps the runtime's std::set of timers in order by
# a copy of each timestamp, so osSetTimer rewriting one in game memory can't leave the set out of order, and recomp/'s
# list under a lock, which has no order to lose, takes none of it. A web from before that commit has timer.cpp's change
# as MERGED_FROM has it.
# And one for a file recomp/'s patches add: tools/web_save_states.patch, the runtime's save states built for wasm,
# which has no native call stack to sign a thread's wait with (the page takes no save states: host/src/frontend.cpp).
# A second run over checkouts the last one left as they are (host/CMakeLists.txt's, after build.sh's) does nothing:
# once a merge since a MERGED_FROM has brought the web's later changes in, the patch made at it no longer comes out of
# them, so web_apply's check that it is in already fails and applying it again would too. The last run's patches and
# the checkouts' changes it left are kept as one hash in the clone's git dir (web_patched).
set -e
cd "$(dirname "$0")/.."
APPLY=tools/N64Recomp-browser/patches/apply.cmake
# web_state: the patches this run applies and the changes in the checkouts it patches, as one hash.
web_state() {
    { cat recomp/*.patch tools/web_patch.sh tools/web_*.patch tools/N64Recomp-browser/patches/*.patch
      for tool in tools/N64Recomp tools/N64ModernRuntime tools/rt64 tools/RecompFrontend; do
          git -C $tool diff HEAD
          git -C $tool submodule foreach --recursive -q 'git diff HEAD'
      done; } | git hash-object --stdin
}
STAMP="$(git rev-parse --absolute-git-dir)/web_patched"
[ "$(cat "$STAMP" 2>/dev/null)" != "$(web_state)" ] || exit 0
MERGED_FROM=494cc8110de23edbc394d977224d7a498fee04b7 # v0.82.0
TIMER_MERGED_FROM=54e69b8287599397f45c803d542467d6c739cac6
WORKLOAD_QUEUE_MERGED_FROM=726888e95c011a8ba208c10e133dbaa33c4d0a9b
RT64_MERGED_FROM=cda4133e8f75214073af0dfd19c31f7cbe73da46 # v0.271.0
RT64_FILES="src/hle/rt64_application.h src/hle/rt64_framebuffer_manager.cpp src/hle/rt64_present_queue.cpp
    src/hle/rt64_state.cpp src/hle/rt64_workload.cpp src/hle/rt64_workload.h src/render/rt64_shader_library.cpp"
RUNTIME_MERGED_FROM=cda4133e8f75214073af0dfd19c31f7cbe73da46 # v0.271.0
RUNTIME_FILES="librecomp/include/librecomp/addresses.hpp librecomp/src/recomp.cpp ultramodern/src/events.cpp"
FRONTEND_MERGED_FROM=cda4133e8f75214073af0dfd19c31f7cbe73da46 # v0.271.0
FRONTEND_FILES="recompinput/src/input_state.cpp recompui/include/recompui/renderer.h
    recompui/src/config/ui_config_page_controls.cpp recompui/src/renderer/rt64_render_context.cpp"
# web_since <name> <tool> <file> [<since>]: the web's change to a file left out, since MERGED_FROM or <since>.
web_since() {
    cmake -P $APPLY "$1" "$2" --since "${4:-$MERGED_FROM}" "$3"
}
# web_apply <tool> <patch>: unless it is in already.
web_apply() {
    git -C "$1" apply --reverse --check "$PWD/$2" 2>/dev/null || git -C "$1" apply "$PWD/$2"
}
# Before rt64's patch: apply.cmake knows a checkout it patched with a three-way merge by its changes, rt64's own
# and its submodules' (plume and hlslpp patched show as dirty), so nothing may change them after.
web_apply tools/rt64 tools/web_rt64_game_frame.patch
web_since rt64 tools/rt64 src/hle/rt64_game_frame.h
WORKLOAD_QUEUE=
if grep -q 'generateInterpolatedFrames && !ext.presentQueue->ext.swapChain->isHidden()' \
        tools/N64Recomp-browser/patches/rt64.patch; then
    WORKLOAD_QUEUE=src/hle/rt64_workload_queue.cpp
    # In already if its hidden-page line is: once the merge below has brought the web's later change to the file in,
    # the patch no longer comes out of it, and a second run (host/CMakeLists.txt's, after build.sh's) would apply it
    # again and fail.
    grep -q 'swapChain->isHidden()' tools/rt64/$WORKLOAD_QUEUE ||
        web_apply tools/rt64 tools/web_rt64_workload_queue.patch
    web_since rt64 tools/rt64 $WORKLOAD_QUEUE $WORKLOAD_QUEUE_MERGED_FROM
fi
web_apply tools/rt64 tools/web_rt64.patch
cmake -P $APPLY rt64 tools/rt64 --since $RT64_MERGED_FROM $RT64_FILES
cmake -P $APPLY plume tools/rt64/src/contrib/plume
cmake -P $APPLY hlslpp tools/rt64/src/contrib/hlslpp
cmake -P $APPLY rt64 tools/rt64 src/hle/rt64_game_frame.h $WORKLOAD_QUEUE $RT64_FILES
web_apply tools/N64ModernRuntime tools/web_save_states.patch
web_apply tools/N64ModernRuntime tools/web_timer.patch
if grep -q TimerSet tools/N64Recomp-browser/patches/N64ModernRuntime.patch; then
    web_since N64ModernRuntime tools/N64ModernRuntime ultramodern/src/timer.cpp $TIMER_MERGED_FROM
fi
web_apply tools/N64ModernRuntime tools/web_n64modernruntime.patch
cmake -P $APPLY N64ModernRuntime tools/N64ModernRuntime --since $RUNTIME_MERGED_FROM $RUNTIME_FILES
cmake -P $APPLY N64ModernRuntime tools/N64ModernRuntime ultramodern/src/timer.cpp $RUNTIME_FILES
cmake -P $APPLY N64Recomp tools/N64ModernRuntime/N64Recomp
web_apply tools/RecompFrontend tools/web_recompfrontend.patch
cmake -P $APPLY RecompFrontend tools/RecompFrontend --since $FRONTEND_MERGED_FROM $FRONTEND_FILES
cmake -P $APPLY RecompFrontend tools/RecompFrontend $FRONTEND_FILES
web_since N64Recomp tools/N64Recomp src/analysis.cpp
cmake -P $APPLY N64Recomp tools/N64Recomp src/analysis.cpp
web_state > "$STAMP"
