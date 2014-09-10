/**
 * Copyright 2014 Brandon Arp
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.arpnetworking.tsdaggregator.model;

import org.joda.time.DateTime;

import java.util.Map;

/**
 * The interface to a record. Records consistent of a timestamp, any number of 
 * named metrics and annotations (arbitrary key-value pairs).
 * 
 * @author Brandon Arp (barp at groupon dot com)
 */
public interface Record {

    /**
     * Gets the time stamp of the record.
     *
     * @return the time stamp.
     */
    DateTime getTime();

    /**
     * Gets metrics.
     *
     * @return the metrics
     */
    Map<String, ? extends Metric> getMetrics();

    /**
     * Gets annotations.
     *
     * @return the annotations
     */
    Map<String, String> getAnnotations();
}
