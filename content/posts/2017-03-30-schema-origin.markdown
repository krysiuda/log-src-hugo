---
layout: post
title:  "schema origin"
date:   2017-03-30
tags:
- soa
- architecture
- schema
- interface
---

# origin of the schema #

I've recently seen a innocent change made to a XSD schema used in integration between two related systems, and the change has really bothered me for next few days.

Let's assume we we have a `systemA` holding record of office supplies ordering. The order in systemA (once created) may be either in state \"ordered\" or \"completed\".
We also have a dedicated `systemB` tracking the process of ordering from a vendor and delivery. Each order has status set to either: \"placed\", \"shipped\", or \"received\".
We want to synchronize order information between the two systems, including historical data about already completed orders.

There are two possible integration scenarios:
- Once a new order is placed in `systemA`, it will push (submit) the information to `systemB`. There will be an \"initial load\" phase moving all historical data across before.
- `systemB` will periodically pull (query for) order information from `systemA`. The historical data will be moved during the first pull.
Of course there would need to be a reverse channel, feeding status updates back to `systemA` but let's leave it, and the \"initial load\", now for sake of simplicity.

Let's now focus on how the order information may be modelled on both ends, and how it impacts the integration architecture.

Obviously, the possible order state information can't be mapped 1:1, since `systemA` has 2 states and `systemB` has 3. But, the mapping is still straightforward since the `systemA` may be kept unaware of the 3rd state in `systemB` (`B`’s set of states superseeds `A`’s states).

Now, let's move to the schema design for the data moving between the two systems. Thus, we actually need to think about: `systemA`, `AtoBmiddleman`, `systemB`.

There are three options:
- We can use the `systemA`’s set of possible states. This implies `systemA`=`middleman` and requires only mappings to be implemented on `systemB` side.
- We can use the `systemB`’s set of possible states. Hence, `systemB`=`middleman` and new mappings are required only on the `systemA` side.
- We can design a new artificial model for the `middleman`, e.g.: \"new\", \"processing\", \"delivered\". It will however require mappings on both sides: `systemA` to `middleman` and `middleman` to `systemB`.

The third option seems unreasonable in many cases, and unavoidable in other. This is sometimes called Cannonical Data Model. I plan to write about it soon.

The two first approaches may seem equivalent, since both require mappings just one \"one side\", but are not.
To understand this, we would need to think about the integration as a provider-consumer relation. Let's use common sense. It's always the provider who really knows what type of service he serves. Consumer may like it and use it, or decide to reach out to other provider. This is exactly same as in a server-client architecture. This is easier to govern, since it is the interface owner, who implements it and is responsible for.
This still holds even in a service locator pattern, where the client chooses from a list of potential providers, or where alternative service versions exist. It is always the provider, who dictates the information exchange schema (contract).
Since the provider is almost never certain who will consume the service it has only limited means to adjust to the consumer.

We may also design the service to implement the consumer's interface. But this will effectivly mean that the provider just happens to be using the consumer's schema. It still has no ownership of it. If a new subscriber will use that service, it will depend on the first subscriber's schema. When a change will be made to the first subscriber's data model, it will affect not only the provider, but also all other subscribers.

The difference is subtle, but has large impact on the potential reusability and maintainability.
