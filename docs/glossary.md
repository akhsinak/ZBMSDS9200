# Glossary

## CAP
SAP Cloud Application Programming Model - framework for building enterprise-ready services.

## CDS
Core Data Services - modeling language used by CAP.

## OData V4
Open Data Protocol version 4 - standard for REST-like APIs with metadata.

## Draft
OData feature (supported by CAP and Fiori elements) that allows users to edit and create data in a temporary "draft" state before activating (saving).

## Fiori elements
SAP UI framework that generates UI (ListReport, ObjectPage, etc.) from OData metadata and annotations.

## List Report
A Fiori floorplan showing a filter bar + table for an entity set.

## Object Page
A Fiori floorplan showing details for a single entity, including create/edit.

## Managed Aspect
A CAP CDS aspect that automatically adds and maintains audit fields like `createdAt`, `createdBy`, `modifiedAt`, `modifiedBy`.

## XSUAA
SAP BTP authentication/authorization service issuing JWT tokens.

## HDI Container
HANA Deployment Infrastructure container; isolated database schema used for deployment.

## MTA
Multi-Target Application - packaging/deployment format for SAP BTP (Cloud Foundry).

## Destination
BTP service that stores connection information to target systems (e.g. UI5 CDN, CAP service route).

## App Router
Component that serves HTML5 apps and proxies requests to backend services with authentication enforcement.
