The DevOps team at Blueteam INC have already preloaded the logs to analyze. We need to figure out where to start. We can use the Kibana Discover page to see what logs are available.

1. Click on the **Discover** link in the left menu.

2. You should see a list of logs. You can expand the time range in the top right hand corner (Calender icon), set this to 30 days since we have received logs for the last 15 days.

The devops team have informed us if we see less thank 100k logs then wait a couple of minutes as elasticsearch is still indexing them.

3. Now challenge yourself! Try to find IoC's in the logs. You can use the search bar to search for specific IoC's.

We have access to these logs:
- Firewall
- SSH
- Web Server

A little tip if you want to filter down to a specific log type you can use the search bar and type `event.dataset :` for example, it will then offer the different types.

Think about what IoC's you would expect to see in these logs and try to find them.

In the next step we will look at how we can use the Kibana Discover page to find IoC's.

Feel free to take as long as you want this exercise is to place you in the shoes of a SOC analyst and to get you thinking about how you would investigate a breach.