# FUVEKON Mobile — Manual test checklist (customer UI)

Use after pulling the customer UI implementation branch. Test on a **regular user** account unless noted.

## Navigation & auth

- [ ] Login as regular user → lands on `/account` (not `/admin`)
- [ ] 5 bottom tabs: Trang chủ / Lịch trình / Vé của tôi / Thông báo / Tài khoản
- [ ] Tab switch preserves state (indexed stack)
- [ ] Detail screens hide bottom nav; back returns to correct tab

## Trang chủ (Màn 12)

- [ ] Hero, bento cards (Vé của tôi, Lịch hôm nay), buy-ticket banner render
- [ ] Shortcuts: Lịch trình, Vé, Artbook, Lost & Found navigate correctly
- [ ] “Mua vé” opens `/ticket/purchase`; back restores home tab
- [ ] Featured event card visible

## Lịch trình (mock)

- [ ] Schedule list loads mock data at `/account/schedule`
- [ ] Activity detail opens full-screen from list
- [ ] Bookmark → conflict dialog (Màn 19) when overlapping
- [ ] Personal itinerary at `/account/schedule/my`
- [ ] Event detail, venue map, venue detail routes work

## Vé

- [ ] My ticket shows status badge at `/account/ticket`
- [ ] QR displays when ticket approved/admin-granted
- [ ] Upgrade flow at `/account/ticket/upgrade` (if eligible)
- [ ] Purchase/payment at `/ticket/purchase` unchanged

## Thông báo

- [ ] List with mint cards at `/account/notifications`
- [ ] Tap item → detail at `/account/notifications/:id`
- [ ] Unread items marked read on detail open

## Profile & submissions

- [ ] Profile mint card layout at `/account/profile`
- [ ] Edit profile saves
- [ ] Settings: theme + locale toggles work
- [ ] Change password submits to API
- [ ] Submissions hub lists panel/talent/conbook
- [ ] Dealer booth + staff pages (if dealer role)

## Lost & Found

- [ ] Public list/search at `/lost-found`
- [ ] Item detail at `/lost-found/:id`
- [ ] Report form at `/lost-found/report`
- [ ] Track request at `/lost-found/requests/:id`

## Theme & i18n

- [ ] Dark theme: canvas `#131313`, primary `#a9cfb8`, mint cards `#E4EEE3`
- [ ] Bottom nav blur + `#07131A` background
- [ ] Be Vietnam Pro typography
- [ ] VI/EN labels on nav and new screens

## Regression

- [ ] Unverified user restricted to profile + change-password + settings
- [ ] Staff/admin login still routes to `/admin`
- [ ] Landing (`/`), auth, payment screens unchanged
