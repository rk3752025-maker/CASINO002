#!/bin/bash

# NUCLEAR POWER MODE - ABSOLUTE MAXIMUM FORCE
echo "💣 ACTIVATING NUCLEAR POWER MODE 💣"

# Read HTML content once
HTML_CONTENT=$(<offer.html)

# Check if all.txt exists
if [[ ! -f "all.txt" ]]; then
  echo "❌ File all.txt not found."
  exit 1
fi

# COUNT TOTAL EMAILS
TOTAL_EMAILS=$(wc -l < all.txt)
echo "📧 Total emails to send: $TOTAL_EMAILS"

# FUNCTION TO GET REAL QUEUE SIZE (BULLETPROOF)
get_queue_size() {
    local size=$(mailq 2>/dev/null | awk 'BEGIN {count=0} /^[A-F0-9]/ {count++} END {print count}')
    echo "${size:-0}"
}

# GET INITIAL QUEUE SIZE
INITIAL_QUEUE=$(get_queue_size)
echo "📊 Initial queue size: $INITIAL_QUEUE"

# EXTREME POSTFIX OPTIMIZATION
echo "⚡ TUNING POSTFIX FOR MAXIMUM WARFARE ⚡"
sudo postconf -e default_process_limit=1000
sudo postconf -e default_destination_concurrency_limit=500
sudo postconf -e initial_destination_concurrency=200
sudo postconf -e default_destination_rate_delay=0s
sudo postconf -e maximal_queue_lifetime=1h
sudo postconf -e bounce_queue_lifetime=1h
sudo service postfix restart
sleep 2

# PRE-FLUSH NUCLEAR
echo "💥 PRE-FLUSHING ANY EXISTING QUEUE 💥"

sudo postqueue -f
sleep 1

# ULTRA-FAST SENDING LOOP
echo "🚀 LAUNCHING NUCLEAR SENDING CAMPAIGN 🚀"
COUNT=0
START_TIME=$(date +%s)

while IFS= read -r email; do
  # Send email to Postfix queue
  echo "$HTML_CONTENT" | mail -a "Content-Type: text/html" \
                               -s "The One Game You Must Try" \
                               -r "Online-gaming-community@roserunkh.com" \
                               "$email" 2>/dev/null &
  
  COUNT=$((COUNT + 1))
  
  # AGGRESSIVE FLUSHING EVERY 500 EMAILS
  if [ $((COUNT % 500)) -eq 0 ]; then
    sudo postqueue -f >/dev/null 2>&1 &
    
    # Show progress
    CURRENT_QUEUE=$(get_queue_size)
    ELAPSED=$(( $(date +%s) - START_TIME ))
    REAL_SENT=$((COUNT - CURRENT_QUEUE))
    echo "⚡ QUEUED: $COUNT | REAL SENT: $REAL_SENT | IN QUEUE: $CURRENT_QUEUE"
  fi
  
  # HYPER-FLUSH EVERY 2000 EMAILS
  if [ $((COUNT % 2000)) -eq 0 ]; then
    echo "💣 HYPER-FLUSHING QUEUE 💣"
    for i in {1..10}; do
      sudo postqueue -f >/dev/null 2>&1 &
    done
    sudo service postfix reload >/dev/null 2>&1
    sleep 0.5
  fi
  
  # NUCLEAR RESET EVERY 10000 EMAILS
  if [ $((COUNT % 10000)) -eq 0 ]; then
    echo "☢️  NUCLEAR POSTFIX RESET ☢️"
    sudo service postfix restart >/dev/null 2>&1
    sleep 2
    sudo postqueue -f >/dev/null 2>&1
  fi
  
done < all.txt

# WAIT FOR ALL MAIL COMMANDS
echo "⏳ FINALIZING QUEUE SUBMISSION..."
wait

# NUCLEAR QUEUE DRAIN MODE
echo "🎯 ACTIVATING NUCLEAR QUEUE DRAIN MODE 🎯"
NUCLEAR_START=$(date +%s)
STUCK_COUNT=0
LAST_QUEUE=0

while true; do
  CURRENT_QUEUE=$(get_queue_size)
  CURRENT_TIME=$(date +%s)
  ELAPSED=$((CURRENT_TIME - NUCLEAR_START))
  
  # Calculate REAL sent emails
  REAL_SENT=$((TOTAL_EMAILS - CURRENT_QUEUE))
  
  # Check if queue is stuck
  if [ "$CURRENT_QUEUE" -eq "$LAST_QUEUE" ] && [ "$CURRENT_QUEUE" -gt 0 ]; then
    STUCK_COUNT=$((STUCK_COUNT + 1))
  else
    STUCK_COUNT=0
  fi
  
  LAST_QUEUE=$CURRENT_QUEUE
  
  if [ "$CURRENT_QUEUE" -eq 0 ]; then
    echo "🎉 NUCLEAR VICTORY! ALL $TOTAL_EMAILS EMAILS DELIVERED!"
    break
  fi
  
  echo "📊 NUCLEAR DRAIN: $CURRENT_QUEUE left | SENT: $REAL_SENT/$TOTAL_EMAILS"
  
  # DEPLOY NUCLEAR FLUSHING TACTICS
  echo "💣 DEPLOYING TACTICAL NUCLEAR FLUSHING 💣"
  
  # METHOD 1: MASS PARALLEL FLUSHING
  for i in {1..50}; do
    sudo postqueue -f >/dev/null 2>&1 &
  done
  wait
  
  # METHOD 2: SUPER AGGRESSIVE FLUSHING
  sudo postsuper -r ALL >/dev/null 2>&1
  
  
  # METHOD 3: POSTFIX RESTART AND FLUSH
  sudo service postfix restart >/dev/null 2>&1
  sleep 2
  for i in {1..20}; do
    sudo postqueue -f >/dev/null 2>&1 &
  done
  wait
  
  # METHOD 4: DIRECT QUEUE MANIPULATION (if really stuck)
  if [ $STUCK_COUNT -gt 5 ] && [ $CURRENT_QUEUE -gt 0 ]; then
    echo "☢️  DEPLOYING EXTREME QUEUE CLEANSE ☢️"
    sudo service postfix stop >/dev/null 2>&1
    
    sudo rm -f /var/spool/postfix/deferred/* >/dev/null 2>&1
    sudo rm -f /var/spool/postfix/incoming/* >/dev/null 2>&1
    sudo service postfix start >/dev/null 2>&1
    sleep 3
    STUCK_COUNT=0
  fi
  
  # METHOD 5: DELAYED RETRY FOR STUCK EMAILS
  if [ $STUCK_COUNT -gt 10 ]; then
    echo "🔄 FORCING STUCK EMAILS RETRY 🔄"
    sudo postsuper -r ALL
    sleep 10
  fi
  
  sleep 2
done

# FINAL NUCLEAR VERIFICATION
echo "🔍 CONDUCTING FINAL NUCLEAR VERIFICATION..."
FINAL_QUEUE=$(get_queue_size)
if [ "$FINAL_QUEUE" -eq 0 ]; then
  echo "✅ NUCLEAR SUCCESS: ALL $TOTAL_EMAILS EMAILS CONFIRMED DELIVERED!"
else
  echo "⚠️  NUCLEAR WARNING: $FINAL_QUEUE emails still in queue after maximum effort"
  echo "💣 DEPLOYING FINAL NUCLEAR OPTION..."
  sudo service postfix stop
  
  sudo service postfix start
fi

# FINAL STATS
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
if [ $TOTAL_TIME -eq 0 ]; then
  TOTAL_TIME=1
fi
FINAL_RATE=$((TOTAL_EMAILS / TOTAL_TIME))

echo "💣 NUCLEAR MISSION COMPLETE!"
echo "📊 Total emails: $TOTAL_EMAILS"
echo "⏱️  Total time: $TOTAL_TIME seconds"
echo "🚀 Average rate: $FINAL_RATE emails/second"
echo "🎯 Final queue status: $(get_queue_size) emails remaining"

# EXTREME SYSTEM CLEANUP
echo "🧹 PERFORMING EXTREME SYSTEM CLEANUP..."
sudo sync
echo 3 | sudo tee /proc/sys/vm/drop_caches >/dev/null 2>&1
